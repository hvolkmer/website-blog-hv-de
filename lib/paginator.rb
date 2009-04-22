module Paginator
  def pagination_links(page = nil)
    current_url = @page.url
    render :partial => "/pagination", :locals => { :current_url => current_url}
  end
  
  def debug_output(page)
    out = "<pre>"
    out << "Page  url: #{@page.url} \n"
    out << "Pager first url: #{@pager.first.url}  \n"
    out << "Pager prev url: #{@pager.prev.url if @pager.prev?}  \n"
    out << "Pager next url: #{@pager.next.url if @pager.next?}  \n"
    out << "Pager last url: #{@pager.last.url}  \n"
    out << "</pre>"
  end
  
  def show_first_page?(current_url)
    @pager.first.url != current_url && 
    @pager.prev.url != @pager.first.url
  end
  
  def show_last_page?(current_url)
    @pager.last.url != current_url && 
    @pager.last.url != @pager.next.url
  end
  
end

Webby::Helpers.register(Paginator)
