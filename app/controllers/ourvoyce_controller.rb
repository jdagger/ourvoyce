class OurvoyceController < ApplicationController
  def index
    @states = State.find(:all, :order => "name")
    if params[:state].nil?
      @ages = NationalAge.first
    else
      state = State.where("abbreviation = ?", params[:state]).first
      if(!state.nil?)
        @ages = StateAgeLookup.where("state_id = ?", state.id).first
      end
    end
  end
end