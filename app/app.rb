require 'sinatra'
require 'sinatra/cross_origin'
require_relative './controllers/items_controller'
require_relative './controllers/article_controller'
require_relative './controllers/_config_controller'
require_relative './controllers/translate_controller'

use ConfigController
use ItemsController
use ArticleController
use TranslateController