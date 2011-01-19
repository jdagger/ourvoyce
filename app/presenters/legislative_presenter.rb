class LegislativePresenter < Presenter
  attr_accessor :senators
  attr_accessor :representatives

  def initialize
    super
    self.senators = []
    self.representatives = []
  end
end
