require './config/dependency/utils'
require './config/dependency/repositories'

require './services/redis_service'
require './services/article_service'

redis_service = RedisService.new
messages = YAML.load_file('./config/friendlyMessages.yml')

ARTICLE_SERVICE = ArticleService.new(
  redis_service,
  UNIT_REPOSITORY,
  messages
)