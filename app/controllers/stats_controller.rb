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

    count = 0
    stats =  User.find(:all, :select => "zip_code, count(zip_code) as count", :group => :zip_code)
    stats.each do |s|
      zip = Zip.where("zip = ?", s.zip_code).first
      if ! zip.nil?
        zip.user_count = s.count
        zip.save
        count += 1
      end
    end
    redirect_to :action => :index, :notice => "Updated #{count} zip records"
  end

  #Calculate total users in each state
  def state_user_counts
    #Reset state counts
    State.update_all(:user_count => 0)

    count = 0

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
      count += 1
    end
    redirect_to :action => :index, :notice => "Updated #{count} state records"
  end

  def national_age_counts
    count = 0

    #Reset table
    NationalAge.delete_all

    national_age = NationalAge.new
    #Initialize ages
    (1..100).each do |n|
      national_age["age_#{n}"] = 0
    end

    stats = User.find(:all, :select => 'birth_year, count(birth_year) as count', :group => 'birth_year')
    stats.each do |s|
     #TODO make year dynamic
      age = 2011 - s.birth_year
      if age > 0 && age <= 100
        national_age["age_#{age}"] = s.count
      end
    end
    national_age.save

    redirect_to :action => :index, :notice => "Updated national ages"
  end

  def state_population_counts
    count = 0

    t.integer :state_id
    t.integer :user_count
    t.float :percent_of_population
    
    redirect_to :action => :index, :notice => "Updated #{count} state population records"
  end
end