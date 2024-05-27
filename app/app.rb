require 'sinatra'
require 'sinatra/cross_origin'

require './controllers/redis_controller'
require './controllers/items_controller'
require './controllers/article_controller'
require './controllers/concerns/config_http'
require './controllers/articleViews_controller'
require './controllers/articleContent_controller'

use ConfigController

use RedisController
use ItemsController
use ArticleController
use ArticleViewsController
use ArticleContentController

set :bind, '0.0.0.0'
