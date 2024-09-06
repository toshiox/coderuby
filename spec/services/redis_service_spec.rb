require 'rspec'
require 'json'
require_relative '../../app/services/redis_service'

RSpec.describe RedisService do
  let(:redis) { instance_double(Redis) }
  let(:service) { described_class.new(redis) }

  describe '#set_list_articles' do
    let(:articles) do
      [
        { id: '1', title: 'Article 1', subtitle: 'Subtitle 1', resume: 'Resume 1' },
        { id: '2', title: 'Article 2', subtitle: 'Subtitle 2', resume: 'Resume 2' }
      ].to_json
    end
    let(:language) { 'en' }

    before do
      allow(redis).to receive(:exists).and_return(0)
      allow(redis).to receive(:set)
      allow(redis).to receive(:sadd?)
    end

    it 'parses the articles JSON' do
      expect(JSON).to receive(:parse).with(articles).and_call_original
      service.set_list_articles(articles, language)
    end

    it 'sets each article in Redis' do
      JSON.parse(articles).each do |article|
        article_id = "article:#{article['id']}_#{language}"
        expect(redis).to receive(:set).with(article_id, article.to_json)
      end
      service.set_list_articles(articles, language)
    end

    it 'adds each article ID to the language set in Redis' do
      JSON.parse(articles).each do |article|
        article_id = "article:#{article['id']}_#{language}"
        expect(redis).to receive(:sadd?).with("language:#{language}", article_id)
      end
      service.set_list_articles(articles, language)
    end

    it 'returns true' do
      result = service.set_list_articles(articles, language)
      expect(result).to be true
    end
  end

  describe '#set_article' do
    let(:article) { { 'id' => '1', 'title' => 'Article 1', 'subtitle' => 'Subtitle 1', 'resume' => 'Resume 1' } }
    let(:article_json) { article.to_json }
    let(:language) { 'en' }
    let(:article_id) { "article:#{article['id']}_#{language}" }

    before do
      allow(service).to receive(:exist_article).and_return(0)
      allow(redis).to receive(:set)
      allow(redis).to receive(:sadd?)
    end

    context 'when article is a JSON string' do
      it 'parses the article JSON' do
        expect(JSON).to receive(:parse).with(article_json).and_call_original
        service.set_article(article_json, language)
      end

      it 'sets the article in Redis' do
        expect(redis).to receive(:set).with(article_id, article_json)
        service.set_article(article_json, language)
      end

      it 'adds the article ID to the language set in Redis' do
        expect(redis).to receive(:sadd?).with("language:#{language}", article_id)
        service.set_article(article_json, language)
      end
    end

    context 'when article is a hash' do
      it 'does not parse the article' do
        expect(JSON).not_to receive(:parse)
        service.set_article(article, language)
      end

      it 'sets the article in Redis' do
        expect(redis).to receive(:set).with(article_id, article.to_json)
        service.set_article(article, language)
      end

      it 'adds the article ID to the language set in Redis' do
        expect(redis).to receive(:sadd?).with("language:#{language}", article_id)
        service.set_article(article, language)
      end
    end

    context 'when article already exists' do
      before do
        allow(service).to receive(:exist_article).with(article_id).and_return(1)
      end

      it 'does not set the article in Redis' do
        expect(redis).not_to receive(:set)
        service.set_article(article, language)
      end

      it 'does not add the article ID to the language set in Redis' do
        expect(redis).not_to receive(:sadd?)
        service.set_article(article, language)
      end
    end
  end

  describe '#set_articles_content' do
    let(:article) { { article_id: '1', title: 'Article 1', subtitle: 'Subtitle 1', resume: 'Resume 1' } }
    let(:language) { 'en' }
    let(:article_id) { "article_content:#{article[:article_id].to_s}_#{language}" }

    before do
      allow(service).to receive(:exist_article).and_return(0)
      allow(redis).to receive(:set)
      allow(redis).to receive(:sadd?)
    end

    context 'when article does not exist' do
      it 'sets the article content in Redis' do
        expect(redis).to receive(:set).with(article_id, article.to_json)
        service.set_articles_content(article, language)
      end

      it 'adds the article ID to the language set in Redis' do
        expect(redis).to receive(:sadd?).with("language:#{language}", article_id)
        service.set_articles_content(article, language)
      end
    end

    context 'when article already exists' do
      before do
        allow(service).to receive(:exist_article).with(article_id).and_return(1)
      end

      it 'does not set the article content in Redis' do
        expect(redis).not_to receive(:set)
        service.set_articles_content(article, language)
      end

      it 'does not add the article ID to the language set in Redis' do
        expect(redis).not_to receive(:sadd?)
        service.set_articles_content(article, language)
      end
    end
  end

  describe '#get_article' do
    let(:article_id) { '1' }
    let(:article) { { 'id' => '1', 'title' => 'Article 1', 'subtitle' => 'Subtitle 1', 'resume' => 'Resume 1' } }
    let(:article_json) { article.to_json }

    before do
      allow(redis).to receive(:get).with("article:#{article_id}").and_return(article_json)
    end

    it 'retrieves the article from Redis' do
      expect(redis).to receive(:get).with("article:#{article_id}")
      service.get_article(article_id)
    end

    it 'returns the article as JSON' do
      result = service.get_article(article_id)
      expect(result).to eq(article_json)
    end
  end

  describe '#get_article_content' do
    let(:article_id) { '1' }
    let(:article_content) { { 'content' => 'This is the content of the article.' } }
    let(:article_content_json) { article_content.to_json }

    before do
      allow(redis).to receive(:get).with("article_content:#{article_id}").and_return(article_content_json)
    end

    it 'retrieves the article content from Redis' do
      expect(redis).to receive(:get).with("article_content:#{article_id}")
      service.get_article_content(article_id)
    end

    it 'returns the article content as JSON' do
      result = service.get_article_content(article_id)
      expect(result).to eq(article_content_json)
    end
  end

  describe '#exist_article' do
    let(:article_id) { '1' }

    context 'when the article exists' do
      before do
        allow(redis).to receive(:exists).with(article_id).and_return(1)
      end

      it 'returns true' do
        result = service.exist_article(article_id)
        expect(result).to eq(1)
      end
    end

    context 'when the article does not exist' do
      before do
        allow(redis).to receive(:exists).with(article_id).and_return(0)
      end

      it 'returns false' do
        result = service.exist_article(article_id)
        expect(result).to eq(0)
      end
    end
  end

  describe '#list_all_articles' do
    let(:language) { 'en' }
    let(:keys) { ['article:1_en', 'article:2_en'] }
    let(:article1) { { 'id' => '1', 'title' => 'Article 1', 'subtitle' => 'Subtitle 1', 'resume' => 'Resume 1' } }
    let(:article2) { { 'id' => '2', 'title' => 'Article 2', 'subtitle' => 'Subtitle 2', 'resume' => 'Resume 2' } }
    let(:article1_json) { article1.to_json }
    let(:article2_json) { article2.to_json }

    before do
      allow(redis).to receive(:smembers).with("language:#{language}").and_return(keys)
      allow(redis).to receive(:get).with('article:1_en').and_return(article1_json)
      allow(redis).to receive(:get).with('article:2_en').and_return(article2_json)
    end

    it 'retrieves all article keys for the given language from Redis' do
      expect(redis).to receive(:smembers).with("language:#{language}")
      service.list_all_articles(language)
    end

    it 'retrieves each article from Redis' do
      keys.each do |key|
        expect(redis).to receive(:get).with(key)
      end
      service.list_all_articles(language)
    end

    it 'returns a list of articles' do
      result = service.list_all_articles(language)
      expect(result).to eq([article1, article2])
    end

    context 'when an article key does not have a corresponding value' do
      before do
        allow(redis).to receive(:get).with('article:1_en').and_return(nil)
      end

      it 'does not include the article in the result' do
        result = service.list_all_articles(language)
        expect(result).to eq([article2])
      end
    end
  end

  describe '#cleanMemory' do
    before do
      allow(redis).to receive(:flushdb)
      allow(redis).to receive(:flushall)
    end

    it 'flushes the database' do
      expect(redis).to receive(:flushdb)
      service.cleanMemory
    end

    it 'flushes all databases' do
      expect(redis).to receive(:flushall)
      service.cleanMemory
    end
  end
end