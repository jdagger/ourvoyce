class MediaPresenter < Presenter
  attr_accessor :media_types
  attr_accessor :second_level
  attr_accessor :third_level

  def initialize
    super
    self.media_types = []
    self.second_level = []
    self.third_level = []
  end
end