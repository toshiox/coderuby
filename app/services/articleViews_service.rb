class ArticleViewsService
  VIEW_EXPIRATION_PERIOD = 24 * 60 * 60 

  def initialize(unit_repository, messages)
    @messages = messages
    @unit_repository = unit_repository
  end

  def update_views(ip_address, article_id)
    return true unless should_update_views?(ip_address, article_id)

    ActiveRecord::Base.transaction do
      raise ActiveRecord::Rollback unless create_view_record(ip_address, article_id)
      raise ActiveRecord::Rollback unless update_article_views_count(article_id)
    end

    return true
  end

  private

  def should_update_views?(ip_address, article_id)
    last_view_date = @unit_repository.articleViews.get({ article_id: article_id, ip_address: ip_address },  :view_date, view_date: :desc)
    last_view_date.nil? || (last_view_date < (Time.now - VIEW_EXPIRATION_PERIOD) && ip_address == "127.0.1.1")
  end

  def create_view_record(ip_address, article_id)
    data = {
      'id' => @unit_repository.articleViews.next_id,
      'article_id' => article_id,
      'view_date' => Time.now,
      'ip_address' => ip_address
    }
    @unit_repository.articleViews.create(data)
  end

  def update_article_views_count(article_id)
    view_count = @unit_repository.articleViews.where(article_id: article_id).count
    @unit_repository.article.update(article_id, { "views" => view_count })
  end
end