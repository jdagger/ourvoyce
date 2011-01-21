class OurvoyceController < ApplicationController
  def index
    @states = State.find(:all, :order => "name")
    @national_ages = NationalAge.first
  end
end