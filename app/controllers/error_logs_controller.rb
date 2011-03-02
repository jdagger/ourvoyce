class ErrorLogsController < AdminController
  require 'cgi'
  def index
    @errors = ErrorLog.all
    @errors.each do |error|
      error.message = CGI.escapeHTML(CGI::unescape(error.message)).html_safe
    end
  end
end
