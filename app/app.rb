require 'sinatra'
# require_relative './controllers/items_controller'
require_relative './controllers/article_controller'

configure do
end

# use ItemsController
use ArticleController