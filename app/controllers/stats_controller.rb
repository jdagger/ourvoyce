class StatsController < ApplicationController
  include SsprCalculations

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
    begin_time = Time.now

    Corporation.update_all("social_score=0, participation_rate=0")


    votes = CorporationSupport.find(:all, :select => ["corporation_id as id", :support_type, "count(support_type) as count"], :group => [:corporation_id, :support_type])
    tabulate_votes votes

    Corporation.transaction do
      self.updated_attributes.each do |key, value|
        Corporation.update_all("social_score=#{value[:social_score]}, participation_rate=#{value[:participation_rate]}", :id => key)
      end
    end

    end_time = Time.now

    redirect_to :action => :index, :notice => "Corporations SSPR calculated (#{((end_time - begin_time) * 1000).to_i}ms)"
  end

  def media_sspr
    begin_time = Time.now

    Media.update_all("social_score=0, participation_rate=0")
    MediaType.update_all("social_score=0, participation_rate=0")

    #Load the media for Magazines (1), Newspapers (2), TV Shows (5), and Radio Shows (6)
    votes = MediaSupport.find(
      :all, 
      :select => ["media_id as id", :support_type, "count(support_type) as count"], 
      :joins => ["join medias ON medias.id = media_supports.media_id"],
      :conditions => { "medias.media_type_id" => [1,2,5,6] },
      :group => [:support_type, :media_id]
    )
    tabulate_votes votes

    Media.transaction do
      self.updated_attributes.each do |key, value|
        Media.update_all("social_score=#{value[:social_score]}, participation_rate=#{value[:participation_rate]}", :id => key)
      end
    end

    #TV and Radio networks will be identified by the parent_media_id field
    #Get the vote data for all medias that have a parent_media_id
    votes = MediaSupport.find(
      :all,
      :select => ["medias.parent_media_id as id", :support_type, "count(support_type) as count"], 
      :joins => ["join medias on medias.id = media_supports.media_id"],
      :conditions => ["medias.parent_media_id IS NOT NULL"],
      :group => [:support_type, "medias.parent_media_id"]
    )

    tabulate_votes votes

    user_count = User.count
    self.vote_data.each do |key, vote|
      network_show_count = Media.where(:parent_media_id => vote.id).count

      social_score = vote.social_score
      participation_rate = vote.participation_rate(user_count * network_show_count)

      #Write the SSPR back to the record
      Media.update_all("social_score=#{social_score}, participation_rate=#{participation_rate}", :id => vote.id)
    end


    #Calculate SSPR for media_types (Magazine (1), Newspaper (2), TV Show (5), Radio Show (6)
    votes = MediaSupport.find(
      :all,
      :select => ["medias.media_type_id as id", :support_type, "count(support_type) as count"], 
      :joins => ["join medias on medias.id = media_supports.media_id"],
      :conditions => {"medias.media_type_id" =>  [1, 2, 5, 6]},
      :group => [:support_type, "medias.media_type_id"]
    )

    tabulate_votes votes

    self.vote_data.each do |key, vote|
      media_show_count = Media.where(:media_type_id => vote.id).count

      social_score = vote.social_score
      participation_rate = vote.participation_rate(user_count * media_show_count)

      #Write the SSPR back to the record
      case vote.id.to_i
      when (1..2) #Magazine or Newspaper
        MediaType.update_all("social_score=#{social_score}, participation_rate=#{participation_rate}", :id => vote.id)
      when 5 #TV Show, update Television type
        MediaType.update_all("social_score=#{social_score}, participation_rate=#{participation_rate}", :id => 4)
      when 6 #Radio Show, update Radio type
        MediaType.update_all("social_score=#{social_score}, participation_rate=#{participation_rate}", :id => 3)
      end
    end

    end_time = Time.now
    redirect_to :action => :index, :notice => "Media SSPR calculated (#{((end_time - begin_time) * 1000).to_i}ms)"
  end

  def government_sspr
    begin_time = Time.now

    Government.update_all("social_score=0, participation_rate=0")

    votes = GovernmentSupport.find(:all, :select => ["government_id as id", :support_type, "count(support_type) as count"], :group => [:support_type, :government_id])
    tabulate_votes votes

    Government.transaction do
      self.updated_attributes.each do |key, value|
        Government.update_all("social_score=#{value[:social_score]}, participation_rate=#{value[:participation_rate]}", :id => key)
      end
    end


    user_count = User.count

    #State stats for legislatives
    LegislativeState.delete_all
    votes = GovernmentSupport.find(
      :all,
      :select => ["governments.state_id as id", :support_type, "count(support_type) as count"],
      :joins => ["join governments on governments.id = government_supports.government_id"],
      :group => ["governments.state_id", :support_type],
      :conditions => {"governments.government_type_id" => 3}
    )

    tabulate_votes votes

    self.vote_data.each do |key, vote|
      LegislativeState.create :state_id => vote.id, :social_score => vote.social_score, :participation_rate => vote.participation_rate(user_count)
    end

    end_time = Time.now

    redirect_to :action => :index, :notice => "Government SSPR calculated (#{((end_time - begin_time) * 1000).to_i}ms)"
  end


  #Votes
  def generate_corporate_votes
    begin_time = Time.now

    corporate_id = nil
    if !(params[:corp_id].nil? || params[:corp_id].empty?)
      corporate_id = params[:corp_id].to_i
    end

    corp_ids = Corporation.find(:all, :select => "id").to_a #array of corp ids
    user_ids = User.find(:all, :select => "id").to_a #array of user ids

    votes_to_generate = 5000
    votes_generated = 0
    CorporationSupport.transaction do
      while votes_generated < votes_to_generate
        support_type = rand(3)

        if corporate_id.nil?
          corp_id = corp_ids[rand(corp_ids.length)].id
        else
          corp_id = corporate_id
        end
        user_id = user_ids[rand(user_ids.length)].id

        record = CorporationSupport.where("corporation_id = ? AND user_id = ?", corp_id, user_id).first
        if record.nil?
          CorporationSupport.create(:bypass_audit => true, :corporation_id => corp_id, :user_id => user_id, :support_type => support_type)
        else
          CorporationSupport.update_all("support_type=#{support_type}", "corporation_id=#{corp_id} AND user_id=#{user_id}")
        end
        votes_generated += 1
      end
    end

    vote_count = CorporationSupport.count 

    end_time = Time.now

    redirect_to :action => :index, :notice => "Corporation votes generated (#{vote_count} total corp votes. #{((end_time-begin_time)*5000).to_i}ms)"
  end

  def generate_government_votes
    begin_time = Time.now

    gov_ids = Government.find(:all, :select => "id").to_a #array of government ids
    user_ids = User.find(:all, :select => "id").to_a #array of user ids

    votes_to_generate = 5000
    votes_generated = 0
    GovernmentSupport.transaction do
      while votes_generated < votes_to_generate
        support_type = rand(3)
        gov_id = gov_ids[rand(gov_ids.length)].id
        user_id = user_ids[rand(user_ids.length)].id
        record = GovernmentSupport.where("government_id = ? AND user_id = ?", gov_id, user_id).first
        if record.nil?
          GovernmentSupport.create(:bypass_audit => true, :government_id => gov_id, :user_id => user_id, :support_type => support_type)
        else
          GovernmentSupport.update_all("support_type=#{support_type}", "government_id=#{gov_id} AND user_id=#{user_id}")
        end
        votes_generated += 1
      end
    end

    vote_count = GovernmentSupport.count

    end_time = Time.now

    redirect_to :action => :index, :notice => "Government votes generated (#{vote_count} total government votes. #{((end_time-begin_time) * 1000).to_i}ms)"
  end

  def generate_media_votes
    begin_time = Time.now

    media_ids = Media.find(:all, :select => "id").to_a #array of media ids
    user_ids = User.find(:all, :select => "id").to_a #array of user ids

    votes_to_generate = 5000
    votes_generated = 0
    MediaSupport.transaction do
      while votes_generated < votes_to_generate
        support_type = rand(3)
        media_id = media_ids[rand(media_ids.length)].id
        user_id = user_ids[rand(user_ids.length)].id
        record = MediaSupport.where("media_id = ? AND user_id = ?", media_id, user_id).first
        if record.nil?
          MediaSupport.create(:bypass_audit => true, :media_id => media_id, :user_id => user_id, :support_type => support_type)
        else
          MediaSupport.update_all("support_type=#{support_type}", "media_id=#{media_id} AND user_id=#{user_id}")
        end
        votes_generated += 1
      end
    end

    vote_count = MediaSupport.count

    end_time = Time.now

    redirect_to :action => :index, :notice => "Media votes generated (#{vote_count} total media votes. #{((end_time-begin_time) * 1000).to_i}ms)"
  end


  def generate_corporate_indexes
    Corporation.all.each do |corporation|
      indexes = build_index_array(corporation.name) + build_index_array(corporation.keywords)
      corporation.generated_indexes = indexes.join(' ')
      corporation.save
    end
    redirect_to :action => :index, :notice => "Corporate indexes updated"
  end

  def generate_media_indexes
    Media.all.each do |media|
      indexes = build_index_array(media.name) + build_index_array(media.keywords)
      media.generated_indexes = indexes.join(' ')
      media.save
    end
    redirect_to :action => :index, :notice => "Media indexes updated"
  end

  def generate_government_indexes
    Government.all.each do |gov|
      indexes = build_index_array(gov.name) + build_index_array(gov.first_name) + build_index_array(gov.last_name) + build_index_array(gov.keywords)
      gov.generated_indexes = indexes.join(' ')
      gov.save
    end
    redirect_to :action => :index, :notice => "Government indexes updated"
  end

  private
  def build_index_array(value)
    if value.blank?
      return []
    end

    min_length = 2
    indexes = []
    value.split(' ').each do |word|
      (min_length..word.length).each do |len|
          indexes << word[0, len]
      end
    end
    indexes
  end
end
