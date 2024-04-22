require './repositories/unit_repository'

class ArticleViewsService
  def initialize
    @unit = UnitRepository.new
  end

  def updateViews(ip_address, articleId)
    query = {
      'articleId' => articleId,
      'ipAddress' => ip_address,
      'view_date' => { '$gte' => (Time.now - 12 * 3600) }
    }
    unless @unit.articleViews.any(query) || ip_address == "127.0.0.1"
      data = {
        'articleId' => articleId,
        'view_date' => Time.now,
        'ipAddress' => ip_address
      }
      if @unit.articleViews.find_and_upsert(query, data)
        views = @unit.articleViews.find({ 'articleId' => articleId }).count
        @unit.article.update({ 'id' => articleId }, { '$set' => { "views" => views } }).to_s
      end
    end
  end
end
