require 'rspec'
require 'redis'
require 'json'
require 'active_record'
require_relative '../../app/services/article_service'
require_relative '../../app/repositories/unit_repository'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.define do
  create_table :test_articles, force: true do |t|
    t.string :title
    t.string :subtitle
    t.string :resume
    t.string :tags
    t.string :language
    t.integer :time_read
    t.integer :views
  end
end

module Test
  class Article < ActiveRecord::Base
    self.table_name = 'test_articles'
  end
end

RSpec.describe ArticleService do
  let(:article_repository) { instance_double('ArticleRepository') }
  let(:unit_repository) { instance_double('UnitRepository', article: article_repository) }
  let(:redis_service) { instance_double(RedisService) }
  let(:translator) { instance_double('Translator') }
  let(:service) { described_class.new(redis_service, unit_repository, translator) }

  describe '#list_all_articles' do
    let(:language) { 'en' }
    let(:all_articles) { [Test::Article.new(id: '1', title: 'Article 1'), Test::Article.new(id: '2', title: 'Article 2')] }
    let(:translated_articles) { all_articles.map { |article| article.attributes.merge('language' => language) } }

    it 'returns articles from Redis cache when articles are available in Redis cache' do
      allow(redis_service).to receive(:list_all_articles).with(language).and_return(all_articles)
      result = service.list_all_articles(language)
      expect(result).to eq(all_articles)
    end

    it 'returns nil when articles are not available in Redis cache' do
      allow(redis_service).to receive(:list_all_articles).with(language).and_return(nil)
      allow(unit_repository).to receive_message_chain(:article, :to_array).and_return(nil)
      
      result = service.list_all_articles(language)
      expect(result).to be_nil
    end

    context 'when articles need translation' do
      it 'returns articles without translation if they are already in the requested language' do
        allow(redis_service).to receive(:list_all_articles).with(language).and_return(nil)
        repository_articles = [Test::Article.new(id: '1', title: 'Article 1', language: 'en')]
        allow(article_repository).to receive(:to_array).and_return(repository_articles)
        allow(redis_service).to receive(:set_list_articles).and_return(true)

        result = service.list_all_articles(language)
        expect(result).to eq(repository_articles)
      end

      it 'fetches articles from the repository, translates them, and stores them in Redis' do
        allow(redis_service).to receive(:list_all_articles).with('pt').and_return(nil)
        
        repository_articles = [Test::Article.new(id: '1', title: 'Article 1', language: 'en', tags: 'tags', resume: 'resume', subtitle: 'subtitle'),]
        allow(article_repository).to receive(:to_array).and_return(repository_articles)

        translated_articles = [Test::Article.new(id: '1', title: 'Artigo 1', language: 'en', tags: 'tags', resume: 'resumo', subtitle: 'subtitulo')]
        allow(translator).to receive(:translate_article).and_return(translated_articles)

        allow(redis_service).to receive(:set_list_articles).and_return(true)

        result = service.list_all_articles('pt')
        expect(result).to eq(translated_articles)
      end
    end
  end
end