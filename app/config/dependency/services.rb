require 'yaml'
require '../../services/redis_service'
require '../../services/article_format'
require '../../services/article_service'
require '../../services/translator_service'
require '../../repositories/unit_repository'

redis_service = RedisService.new
article_format = ArticleFormat.new
unit_repository = UnitRepository.new
translator_service = TranslatorService.new
messages = YAML.load_file('./config/friendlyMessages.yml')

ARTICLE_SERVICE = ArticleService.new(
  redis_service: redis_service,
  article_format: article_format,
  translator_service: translator_service,
  unit_repository: unit_repository,
  messages: messages
)