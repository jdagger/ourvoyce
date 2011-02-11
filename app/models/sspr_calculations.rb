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
        (self.positive_votes * 100) / [(self.negative_votes + self.positive_votes), 1].max
      end

      def participation_rate(total_users)
        (self.positive_votes + self.negative_votes + self.neutral_votes) * 100 / total_users
      end
    end
  end

  attr_accessor :updated_attributes
  
  
  
  def tabulate_votes votes
    entities = {}
    
    votes.each do |vote|
      key = "entity_#{vote.id}"

      if !entities.key? key
        entities[key] = Votes.new 
        entities[key].id = vote.id
      end

      case vote.support_type
      when 0
        entities[key].negative_votes = vote.count.to_i
      when 1
        entities[key].positive_votes = vote.count.to_i
      when 2
        entities[key].neutral_votes = vote.count.to_i
      end
    end


    user_count = User.count
    self.updated_attributes ={}
    entities.values.each do |vote|
      updated_attributes[vote.id] = {:social_score => vote.social_score, :participation_rate => vote.participation_rate(user_count) }
    end
  end

end
