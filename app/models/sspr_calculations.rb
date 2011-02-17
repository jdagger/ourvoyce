module SsprCalculations

  class Votes
    attr_accessor :id
    attr_accessor :positive_votes
    attr_accessor :neutral_votes
    attr_accessor :negative_votes

    def initialize
      self.id = 0
      self.positive_votes = 0
      self.negative_votes = 0
      self.neutral_votes = 0

      def social_score
        (self.positive_votes * 100) / (self.negative_votes + self.positive_votes) rescue 0
      end

      def participation_rate(total_users)
        (self.positive_votes + self.negative_votes + self.neutral_votes) * 100 / total_users rescue 0
      end
    end
  end

  attr_accessor :updated_attributes
  attr_accessor :vote_data

  def populate_vote_data votes
    self.vote_data = {}

    votes.each do |vote|
      key = "entity_#{vote.id}"

      if !self.vote_data.key? key
        self.vote_data[key] = Votes.new 
        self.vote_data[key].id = vote.id
      end

      case vote.support_type
      when 0
        self.vote_data[key].negative_votes = vote.count.to_i
      when 1
        self.vote_data[key].positive_votes = vote.count.to_i
      when 2
        self.vote_data[key].neutral_votes = vote.count.to_i
      end
    end

  end

  #Populate updated_attributes with the social_score and participation_rate, keyed by media_id
  def tabulate_votes votes
    populate_vote_data votes
    

    user_count = User.count
    self.updated_attributes = {}
    self.vote_data.values.each do |vote|
      updated_attributes[vote.id] = {:social_score => vote.social_score, :participation_rate => vote.participation_rate(user_count) }
    end
  end

end
