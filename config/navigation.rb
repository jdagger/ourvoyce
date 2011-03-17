# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|

  navigation.selected_class = "selected"
  
  # Define the primary navigation
  navigation.items do |primary|
    primary.item :ourvoyce, 'ourvoyce', ourvoyce_url, :class => 'ourvoyce', :highlights_on => /\/ourvoyce*/
    if ! current_user.nil?
      primary.item :myvoyce, 'aaamy voyce', myvoyce_url, :class => 'myvoyce', :highlights_on => /\/myvoyce*/
    end
    primary.item :corporate, 'corporate', corporates_index_url, :class => 'corporate', :highlights_on => /\/corporate*/
    primary.item :government, 'government', government_index_url, :class => 'government', :highlights_on => /\/government*/
    primary.item :media, 'media', media_index_url, :class => 'media', :highlights_on => /\/media*/
    primary.item :work, 'how does this work?', "/how-does-this-work", :class => 'work', :highlights_on => /\/how-does-this-work*/
  end

end
