class ErrorLogsController < ApplicationController
  def index
    @errors = ErrorLog.all
  end
end
