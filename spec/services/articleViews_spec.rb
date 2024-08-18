require 'rspec'
require 'active_record'
require_relative '../../app/repositories/unit_repository.rb'
require_relative '../../app/services/articleViews_service.rb'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.define do
  create_table :article_views, force: true do |t|
    t.integer :article_id
    t.string :ip_address
    t.datetime :viewed_at
  end
end

RSpec.describe ArticleViewsService do
  let(:article_views_repository) { instance_double('ArticleViewsRepository') }
  let(:article_repository) { instance_double('ArticleRepository') }
  let(:unit_repository) { instance_double('UnitRepository', articleViews: article_views_repository, article: article_repository) }
  let(:messages) { double('Messages') }
  let(:service) { described_class.new(unit_repository, messages) }
  let(:ip_address) { '127.0.1.1' }
  let(:article_id) { 1 }
  let(:current_time) { Time.now }

  before do
    allow(Time).to receive(:now).and_return(current_time)
  end

  describe '#update_views' do
    context 'success' do
      it do
        allow(article_views_repository).to receive(:get).and_return(nil)
        allow(article_views_repository).to receive(:next_id).and_return(1)
        allow(article_views_repository).to receive(:create).and_return(true)
        allow(article_views_repository).to receive(:where).with(article_id: article_id).and_return(double(count: 1))
        allow(article_repository).to receive(:update).and_return(true)
    
        expect(service.update_views(ip_address, article_id)).to be true
      end
    end
    
    context 'should_update_views?' do
      it 'article already have been seen in the last 24 hours' do
        expired_time = current_time + (24 * 60 * 60) 
        allow(article_views_repository).to receive(:get).and_return(expired_time)
    
        expect(service.update_views(ip_address, article_id)).to be true
      end
    
      it 'cannot insert local ip' do
        allow(article_views_repository).to receive(:get).and_return(current_time)
    
        expect(service.update_views(ip_address, article_id)).to be true
      end
    end

    context 'create_view_record' do
      it 'creates a new view record fails' do
        allow(article_views_repository).to receive(:get).and_return(nil)
        allow(article_views_repository).to receive(:next_id).and_return(1)
        allow(article_views_repository).to receive(:create).and_return(false)
    
        expect(unit_repository.article).not_to receive(:update)
      end

      it 'next_id fails' do
        allow(article_views_repository).to receive(:get).and_return(nil)
        allow(article_views_repository).to receive(:next_id).and_return(nil)
    
        expect(unit_repository.article).not_to receive(:create)
      end
    end

    context 'update_article_views_count' do
      it 'update article fails' do
        allow(article_views_repository).to receive(:get).and_return(nil)
        allow(article_views_repository).to receive(:next_id).and_return(1)
        allow(article_views_repository).to receive(:create).and_return(true)
        allow(article_views_repository).to receive(:where).with(article_id: article_id).and_return(double(count: 0))
        allow(article_repository).to receive(:update).and_return(false)
    
        expect(service.update_views(ip_address, article_id)).to be true
      end

      it 'count views fails' do
        allow(article_views_repository).to receive(:get).and_return(nil)
        allow(article_views_repository).to receive(:next_id).and_return(1)
        allow(article_views_repository).to receive(:create).and_return(true)
        allow(article_views_repository).to receive(:where).with(article_id: article_id).and_return(nil)
        allow(article_repository).to receive(:update).and_return(false)
    
        expect(unit_repository.article).not_to receive(:update)
      end
    end
  end
end