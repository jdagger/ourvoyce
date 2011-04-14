module ColorHelper
  def color_from_social_score score
    color = 'ffffff'
    if score < 50
      color = 'cb0223'
      #elsif score >= 40 && score <= 60
      #color = 'F88017'
    else
      color = '23b62a'
    end
  end

  #color is based on support type with most votes
  def color_from_vote_count(positive, neutral, negative)
  
    #Rails.logger.error '**********BEGIN********'
    #Rails.logger.error 'positive = %{u}' % { :u => positive }
    #Rails.logger.error 'neutral= %{n}' % { :n => neutral }
    #Rails.logger.error 'negative= %{d}' % { :d => negative }
    
    #set red as the default
    color = 'cb0223' #red
    
    #neutral wins if greater or equal to negative
    if neutral >= negative
      color = 'F88017'
    end
    
    #positive wins if great than neutral and greater or equal to negative
    if positive > neutral and positive >= negative
      color = '23b62a'
    end      
    
    #Rails.logger.error 'color= %{c}' % { :c => color }
    #Rails.logger.error '**********END********'
    
    return color
  end  
  
  #value is between 0 and 100.  100 represents darker, 0 represents lighter
  def shades_of_green value
      
    #Blue shades
    shades = %w( 237aff 2274f3 206de4 1f65d3 1e5ec1 1d57af )
    
    #Bunch of shades
    #shades = %w( 00FF00 00F800 00F000 00E800 00E000 00D800 00D000 00C800 00C000 00B800 00B000 00A800 00A000 009800 009000 008800 008000 007800 007000 006800 006000 005800 005000 004800 004000 003800 003000 002800 002000 )

    #Fewer of shades
    #shades = %w( 00FF00 00D800 00B000 008800 006000 003800 )

    #scale the 'value' to an index in the array and display the color
    #the min/max ensure the value is within the range
    index = [ [shades.length * value / 100, 0].max, shades.length - 1].min
    return shades[index]
  end
end
