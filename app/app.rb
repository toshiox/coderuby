require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/cross_origin'

require './controllers/redis_controller'
require './controllers/article_controller'
require './controllers/concerns/config_http'
require './controllers/articleViews_controller'
require './controllers/articleContent_controller'

require './config/dependency/services'

use ConfigController
use ArticleController, ARTICLE_SERVICE
use RedisController
use ArticleViewsController, ARTICLE_VIEWS_SERVICE
use ArticleContentController, ARTICLE_CONTENT_SERVICE

set :bind, '127.0.1.1'
set :database_file, '../config/database.yml'
