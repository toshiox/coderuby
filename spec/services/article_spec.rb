# spec/services/article_spec.rb
require 'rspec'
require 'active_record'
require 'json'
require_relative '../../app/services/article_service'
require_relative '../../app/services/redis_service'
require_relative '../../app/repositories/unit_repository'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.define do
  create_table :articles, force: true do |t|
    t.integer :article_id
    t.string :content
    t.datetime :created_at
  end
end

class Article < ActiveRecord::Base
end

RSpec.describe ArticleService do
  let(:redis_service) { instance_double(RedisService) }
  let(:unit_repository) { instance_double(UnitRepository) }
  let(:article_repository) { instance_double('ArticleRepository') }
  let(:messages) { {} }
  let(:service) { described_class.new(redis_service, unit_repository, messages) }

  before do
    allow(unit_repository).to receive(:article).and_return(article_repository)
  end

  describe '#get_by_id' do
    let(:id_with_language) { '1_en' }
    let(:id) { '1' }
    let(:language) { 'en' }
    let(:created_at) { "2024-09-06 08:43:47" }
    let(:article) { { title: 'Test Content', subtitle: "Test SubTile", resume: 'Test Resume' } }
    let(:cached_article) { article.to_json }

    context 'when the article is cached' do
      it 'returns the cached article' do
        allow(redis_service).to receive(:get_article).and_return(cached_article)
        result = service.get_by_id(id_with_language)
        expect(result).to eq(article)
      end
    end

    context 'when the article is not cached' do
      before do
        allow(redis_service).to receive(:get_article).with(id_with_language).and_return(nil)
      end

      context 'and the article exists in the repository' do
        before do
          allow(article_repository).to receive(:get).with({ id: id }, [ :title, :subtitle, :resume ]).and_return(['Test Content', 'Test SubTile', 'Test Resume'])
          allow(redis_service).to receive(:set_article)
        end

        it 'returns the article from the repository' do
          result = service.get_by_id(id_with_language)
          expect(result).to eq(article)
        end

        it 'caches the article' do
          expect(redis_service).to receive(:set_article).with(article.to_json, language)
          service.get_by_id(id_with_language)
        end
      end

      context 'and the article does not exist in the repository' do
        before do
          allow(article_repository).to receive(:get).with({ id: id }, [:title, :subtitle, :resume]).and_return(nil)
        end

        it 'returns nil' do
          result = service.get_by_id(id_with_language)
          expect(result).to be_nil
        end
      end
    end
  end
end