require 'sinatra'
require 'sinatra/cross_origin'
require_relative './controllers/redis_controller'
require_relative './controllers/items_controller'
require_relative './controllers/article_controller'
require_relative './controllers/_config_controller'
require_relative './controllers/articleViews_controller'
require_relative './controllers/articleContent_controller'

use ConfigController

use RedisController
use ItemsController
use ArticleController
use ArticleViewsController
use ArticleContentController
