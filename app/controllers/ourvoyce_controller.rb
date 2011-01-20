class OurvoyceController < ApplicationController
  def index
    @states = State.all
    @national_ages = NationalAge.first
  end
end