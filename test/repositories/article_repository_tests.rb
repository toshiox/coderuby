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

  describe 'find' do
    let(:query) { { name: 'test' } }
    let(:options) { {} }
    it 'calls find on the collection with correct parameters' do
      repository.find({ name: 'test' }, options)
      expect(collection).to have_received(:find).with({ name: 'test' }, {})
    end
  end

  describe 'find_one' do
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

    context 'when an exception occurs during the query execution' do
      let(:query) { { 'key' => 'value' } }
      let(:options) { {} }

      it 'raises an error' do
        allow(collection).to receive(:find).with(query, options).and_raise(StandardError)
        expect { repository.find_one(query, options) }.to raise_error(StandardError)
      end
    end
  end

  describe 'insert' do
    let(:data) { { key: 'value' } }

    it 'inserts data into the collection' do
      expect(collection).to receive(:insert_one).with(data)
      repository.insert(data)
    end

    # let(:invalid_data) { { key: nil } }
    # it 'handles invalid data appropriately' do
    #   expect(collection).not_to receive(:insert_one).with(invalid_data)
    #   expect { repository.insert(invalid_data) }.to raise_error(StandardError)
    # end

    context 'when data is nil' do
      it 'does not perform an insertion' do
        expect(collection).not_to receive(:insert_one)
        repository.insert(nil)
      end
    end

    context 'when data is empty' do
      it 'does not perform an insertion' do
        expect(collection).not_to receive(:insert_one)
        repository.insert({})
      end
    end

    context 'when an exception occurs' do
      let(:data) { { key: 'value' } }

      it 'raises an appropriate error' do
        allow(collection).to receive(:insert_one).with(data).and_raise(Mongo::Error::OperationFailure)
        expect { repository.insert(data) }.to raise_error(Mongo::Error::OperationFailure)
      end
    end

    context 'with valid data' do
      let(:valid_data) { { key: 'value' } }

      it 'successfully inserts the data' do
        expect(collection).to receive(:insert_one).with(valid_data)
        repository.insert(valid_data)
      end
    end

  end
end
