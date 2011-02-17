class MediaPresenter < Presenter
  attr_accessor :media_types
  attr_accessor :networks
  attr_accessor :shows
  attr_accessor :force_display_shows

  def initialize
    super
    self.media_types = []
    self.networks = []
    self.shows = []
    self.force_display_shows = false
  end
end
