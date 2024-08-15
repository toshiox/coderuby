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
use RedisController
use ArticleController, ARTICLE_SERVICE
use ArticleViewsController
use ArticleContentController

set :bind, '127.0.1.1'
set :database_file, '../config/database.yml'