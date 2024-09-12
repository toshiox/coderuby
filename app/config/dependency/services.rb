require './config/dependency/utils'
require './config/dependency/repositories'

require './services/redis_service'
require './services/article_service'
require './services/translator_service'
require './services/articleViews_service'
require './services/articleContent_service'

redis_service = RedisService.new
messages = YAML.load_file('./config/friendlyMessages.yml')

translator = TranslatorService.new(
  UNIT_UTILS
)

ARTICLE_SERVICE = ArticleService.new(
  redis_service,
  UNIT_REPOSITORY,
  translator
)

ARTICLE_VIEWS_SERVICE = ArticleViewsService.new(
  UNIT_REPOSITORY,
  messages
)

ARTICLE_CONTENT_SERVICE = ArticleContentService.new(
  redis_service,
  UNIT_REPOSITORY,
  messages,
  translator
)