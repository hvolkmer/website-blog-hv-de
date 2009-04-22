module FinderHelper
  def articles_in_category(category, options = {})
    all_blog_posts_by_date(options) { |page| page.sections.include?(category) if page.sections }                                          
  end

  def articles_with_tag(tag, options = {})
    all_blog_posts_by_date(options) { |page| page.tags.include?(tag) if page.tags }                                          
  end
  
  def subpages
    @pages.find(:all, @page.dir, :sort_by => "title")
  end
  
  def articles_with_at_least_one_tag(tags, options = {})
    return unless tags
    all_blog_posts_by_date(options) do |page|
         page.tags.any? do |tag| 
           tags.include?(tag)
         end if page.tags
     end
  end
  
  def all_blog_posts_by_date(options = {}, &block)
    find_options = {:in_directory => "/", :recursive => true,
                       :sort_by => "created_at", 
                       :reverse => true, 
                       :blog_post => true }.merge(options)
     @pages.find(:all, find_options , &block)
  end

  def all_articles_last_updated_first(options = {}, &block)
    # use updated_at instead of created_at
    find_options = { :in_directory => "/", :recursive => true, :reverse => true, :sort_by => "created_at"}.merge(options) 
    @pages.find(:all, find_options, &block)
  end
  
  def related_articles(page)
    articles = articles_with_at_least_one_tag(page.tags, :limit => 5)
    articles.delete(page) if articles
    articles ||= []
    articles
  end
  
  def link_to_categories(page)
    page.sections.map { |x| link_to(x, "/category/#{x}") }.join(", ") if page.sections
  end
  
  def link_to_tags(page)
    page.tags.map { |x| link_to(x, "/tags/#{x}") }.join(", ") if page.tags
  end
  
  def has_tags?(page)
    !page.tags.nil?
  end
  
end

Webby::Helpers.register(FinderHelper)
