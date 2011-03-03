module ColorHelper
  def color_from_social_score score
    color = 'ffffff'
    if score < 45
      color = 'cb0223'
    elsif score >= 45 && score <= 55
      color = 'F88017'
    else
      color = '23b62a'
    end
  end

  #value is between 0 and 100.  100 represents darker, 0 represents lighter
  def shades_of_green value
    #Bunch of shades
    shades = %w( 00FF00 00F800 00F000 00E800 00E000 00D800 00D000 00C800 00C000 00B800 00B000 00A800 00A000 009800 009000 008800 008000 007800 007000 006800 006000 005800 005000 004800 004000 003800 003000 002800 002000 )

    #Fewer of shades
    #shades = %w( 00FF00 00D800 00B000 008800 006000 003800 )

    #scale the 'value' to an index in the array and display the color
    #the min/max ensure the value is within the range
    index = [ [shades.length * value / 100, 0].max, shades.length - 1].min
    return shades[index]
  end
end
