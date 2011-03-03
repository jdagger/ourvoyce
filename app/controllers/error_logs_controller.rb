class ErrorLogsController < AdminController
  require 'cgi'
  def index
    @error_count = ErrorLog.all.count

    page_size = 10 
    page = [params[:page].to_i, 1].max

    @errors = ErrorLog.order("created_at desc").offset((page - 1) * page_size).limit(page_size)

    @paging = PagingHelper::PagingData.new
    @paging.total_pages = (@error_count.to_f / page_size).ceil
    @paging.current_page = page
    (1..@paging.total_pages).each do |count|
      link = {:link_url => url_for(:controller => :error_logs, :action => :index, :page => count), :page => count}
      @paging.links << link
    end


    @errors.each do |error|
      error.request = CGI.escapeHTML(CGI::unescape(error.request)).html_safe
      error.response = CGI.escapeHTML(CGI::unescape(error.response)).html_safe
    end
  end
end
