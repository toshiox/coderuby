require 'rspec'
require_relative '../../app/repositories/article_repository'

RSpec.describe ArticleRepository do
  let(:collection) { instance_double(Mongo::Collection) }
  let(:collection_view) { Mongo::Collection::View.new(collection) }
  let(:repository) { described_class.new("articles") }

  before do
    client = instance_double(Mongo::Client)
    allow(Mongo::Client).to receive(:new).and_return(client)
    allow(client).to receive(:use).and_return(client)
    allow(client).to receive(:[]).with("articles").and_return(collection)
    allow(collection).to receive(:find).and_return(collection_view)
    allow(collection).to receive(:client).and_return(client)
  end

  describe '#find' do
    let(:query) { { name: 'test' } }
    let(:options) { {} }
    it 'calls find on the collection with correct parameters' do
      repository.find({ name: 'test' }, options)
      expect(collection).to have_received(:find).with({ name: 'test' }, {})
    end
  end

  describe '#find_one' do
    let(:query) { { name: 'test' } }
    let(:options) { {} }

    it 'calls find_one on the collection with correct parameters' do
      allow(collection).to receive(:find).with(query, options).and_return([{"name" => "test"}])
      result = repository.find_one(query, options)
      expect(result).to eq({"name" => "test"})
      expect(collection).to have_received(:find).with(query, options)
    end

    it 'calls find_one and return nil' do
      allow(collection).to receive(:find).with(query, options).and_return([])
      result = repository.find_one(query, options)
      expect(result).to eq(nil)
    end
  end
end
