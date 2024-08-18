require 'rspec'
require 'json'
require_relative '../../app/services/redis_service'

RSpec.describe RedisService do
  let(:service) { RedisService.new }
  let(:redis) { instance_double("Redis") } 

  before do
    allow(Redis).to receive(:new).and_return(redis)
  end

  describe '#set_articles' do
    let(:articles) do
      [
        { 'id' => 1, 'language' => 'en', 'content' => 'Article 1' }.to_json,
        { 'id' => 2, 'language' => 'en', 'content' => 'Article 2' }.to_json
      ].to_json
    end

    it 'sets articles in Redis if they do not exist and returns true' do
      allow(redis).to receive(:exists).and_return(0)
      allow(redis).to receive(:set)
      allow(redis).to receive(:sadd?)

      expect(service.set_articles(articles, 'en')).to be true
    end

    it 'does not set articles in Redis if they already exist and returns false' do
      allow(redis).to receive(:exists).and_return(1)
      expect(service.set_articles(articles, 'en')).to be true
    end
  end
end