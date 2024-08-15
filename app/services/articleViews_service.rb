require './repositories/unit_repository'
require_relative '../models/api/api_response'
class ArticleViewsService
  def initialize
    @unit = UnitRepository.new
    @messages = YAML.load_file('./config/friendlyMessages.yml')
  end

  def updateViews(ip_address, articleId)
    view = @unit.articleViews.get({ article_id: articleId, ip_address: ip_address }, view_date: :desc)
    # puts @unit.articleViews.get({id: > 0}, {id: :desc})
    # if(view.nil? || view.view_date < (Time.now - 24 * 60 * 60)) #&& ip_address == "127.0.1.1")
    #   data = {
    #     'id' => @unit.articleViews.getOnly({id: > 0}, {:id})
    #     'article_id' => articleId,
    #     'view_date' => Time.now,
    #     'ip_address' => ip_address
    #   }
    #   if @unit.articleViews.create(data)
    #     count = @unit.articleViews.all({ article_id: articleId}).count
    #     @unit.article.update(articleId, {"views" => count }).to_s
    #   end
    # end

    return ApiResponse.new(true, @messages['en']['repository']['success']['updateViews'], nil).to_json
  end
end
