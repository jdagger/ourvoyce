class OurvoyceController < ApplicationController
  def index
    @states = State.find(:all, :order => "name")
  end
end
