require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/cross_origin'

require './controllers/redis_controller'
require './controllers/article_controller'
require './controllers/concerns/config_http'
require './controllers/articleViews_controller'
require './controllers/articleContent_controller'

use ConfigController
use RedisController
use ArticleController
use ArticleViewsController
use ArticleContentController

set :bind, '0.0.0.0'
set :database_file, '../config/database.yml'