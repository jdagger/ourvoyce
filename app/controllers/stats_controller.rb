class StatsController < ApplicationController
  def index
    @notice = params[:notice] || ''
  end

  def generate_all
    zip_user_counts
  end

  #Calculate the total number of users in each zip code
  def zip_user_counts
    #Reset the count
    Zip.update_all(:user_count => 0)

    stats =  User.find(:all, :select => "zip_code, count(zip_code) as count", :group => :zip_code)
    stats.each do |s|
      zip = Zip.where("zip = ?", s.zip_code).first
      if ! zip.nil?
        zip.user_count = s.count
        zip.save
      end
    end
    redirect_to :action => :index, :notice => "Updated zip records"
  end

  #Calculate total users in each state
  def state_user_counts
    #Reset state counts
    State.update_all(:user_count => 0)

=begin
    # Expected query
    SELECT s.id, count(s.id) as count
    FROM Users u
    JOIN Zips z ON u.zip_code = z.zip
    JOIN States s ON s.id = z.state_id
    GROUP BY s.id
=end
    stats =  User.find(:all, :select => "states.id, count(states.id) as count", :joins => ['join zips ON zips.zip = users.zip_code', 'join states ON states.id = zips.state_id'], :group => "states.id")
    stats.each do |s|
      state = State.find(s.id)
      state.user_count = s.count
      state.save
    end
    redirect_to :action => :index, :notice => "Updated state records"
  end

  def national_age_counts

    #Reset table
    NationalAge.delete_all

    national_age = NationalAge.new
    #Initialize ages
    (1..100).each do |n|
      national_age["age_#{n}"] = 0
    end

    stats = User.find(:all, :select => 'birth_year, count(birth_year) as count', :group => 'birth_year')
    stats.each do |s|
      age = Time.now.year - s.birth_year
      if age > 0 && age <= 100
        national_age["age_#{age}"] = s.count
      end
    end
    national_age.save

    redirect_to :action => :index, :notice => "Updated national ages"
  end

  def state_age_counts
    StateAgeLookup.delete_all

    #This will return rows of state_id, birth_year, count
    stats =  User.find(:all, :select => "states.id as id, birth_year, count(birth_year) as count", :joins => ['join zips ON zips.zip = users.zip_code', 'join states ON states.id = zips.state_id'], :group => ["states.id", "birth_year"], :order => "states.id")

    state_ages = {}

    #Loop through result set
    stats.each do |row|
      age_row = nil

      #If we've already referenced a state's row, reload.  Otherwise, create
      if state_ages.key?(row.id)
        age_row = state_ages[row.id]
      else
        age_row = StateAgeLookup.new :state_id => row.id
        state_ages[row.id] = age_row
      end

      #Store the count for the given state/age
      age = Time.now.year - row.birth_year
      age_row["age_#{age}"] = row.count
    end

    #Loop through each row and save the values
    state_ages.each do |state_id, age_row|
      age_row.save
    end
    
    redirect_to :action => :index, :notice => "Updated state age records"
  end


  def corporate_sspr
    @corporations = Corporation.all
    total_users = User.all.count

    @corporations.each do |corp|
      neutral = 0
      positive = 0
      negative = 0

      vote_counts = CorporationSupport.find(:all, :select => [:support_type, "count(support_type) as count"], :group => [:support_type], :conditions => {:corporation_id => corp.id})
      vote_counts.each do |vote|
        case vote.support_type
        when 0
          negative = vote.count.to_i
        when 1
          positive = vote.count.to_i
        when 2
          neutral = vote.count.to_i
        end
      end

      #votes = CorporationSupport.find(:all, :conditions => {:corporation_id => corp.id}).count
      votes = [negative + neutral + positive, 1].max

      corp.social_score = (positive * 100 + neutral * 50) / votes
      corp.participation_rate = votes * 100 / total_users
      corp.save
    end
    redirect_to :action => :index, :notice => "Corporations SSPR calculated"
  end

  def media_sspr
    @medias = Media.all
    total_users = User.all.count

    @medias.each do |media|
      neutral = 0
      positive = 0
      negative = 0
      vote_counts = MediaSupport.find(:all, :select => [:support_type, "count(support_type) as count"], :group => [:support_type], :conditions => {:media_id => media.id})
      vote_counts.each do |vote|
        case vote.support_type
        when 0
          negative = vote.count.to_i
        when 1
          positive = vote.count.to_i
        when 2
          neutral = vote.count.to_i
        end
      end

      votes = [negative + neutral + positive, 1].max

      media.social_score = (positive * 100 + neutral * 50) / votes
      media.participation_rate = votes * 100 / total_users
      media.save
    end
    redirect_to :action => :index, :notice => "Media SSPR calculated"
  end

  def government_sspr
    @governments = Government.all
    total_users = User.all.count

    @governments.each do |gov|
      neutral = 0
      positive = 0
      negative = 0
      vote_counts = GovernmentSupport.find(:all, :select => [:support_type, "count(support_type) as count"], :group => [:support_type], :conditions => {:government_id => gov.id})
      vote_counts.each do |vote|
        case vote.support_type
        when 0
          negative = vote.count.to_i
        when 1
          positive = vote.count.to_i
        when 2
          neutral = vote.count.to_i
        end
      end

      votes = [negative + neutral + positive, 1].max

      gov.social_score = (positive * 100 + neutral * 50) / votes
      gov.participation_rate = votes * 100 / total_users
      gov.save
    end
    redirect_to :action => :index, :notice => "Government SSPR calculated"
  end


  def media_state_sspr
    MediaState.delete_all

    State.all.each do |state|
      MediaState.create :state_id => state.id, :social_score => rand(100), :participation_rate => rand(100)
    end
    redirect_to :action => :index, :notice => "Updated media state sspr"
  end

  def government_state_sspr
    LegislativeState.delete_all

    State.all.each do |state|
      LegislativeState.create :state_id => state.id, :social_score => rand(100), :participation_rate => rand(100)
    end
    redirect_to :action => :index, :notice => "Updated legislative state sspr"
  end


  #Votes
  def generate_corporate_votes
    # counts
    corp_count = Corporation.all.count
    user_count = User.all.count

    corporate_id = nil

    if !(params[:corp_id].nil? || params[:corp_id].empty?)
      corporate_id = params[:corp_id].to_i
    end

    votes_to_generate = 1000
    votes_generated = 0
    while votes_generated < votes_to_generate
      random_user = User.find(:first, :offset => rand(user_count))
      support_type = rand(3) #0, 1, or 2

      if corporate_id.nil?
        random_corp = Corporation.find(:first, :offset => rand(corp_count))
        CorporationSupport.change_support(random_corp.id, random_user.id, support_type)
      else
        CorporationSupport.change_support(corporate_id, random_user.id, support_type)
      end

      votes_generated += 1
    end

    vote_count = CorporationSupport.all.count

    redirect_to :action => :index, :notice => "Corporation votes generated (#{vote_count} total corp votes)"
  end


end
