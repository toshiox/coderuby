require 'rspec'
require_relative '../../app/repositories/unit_repository.rb'
require_relative '../../app/services/articleViews_service.rb'

RSpec.describe ArticleViewsService do
  let(:article_views_repository) { instance_double('ArticleViewsRepository') }
  let(:article_repository) { instance_double('ArticleRepository') }
  let(:unit_repository) { UnitRepository.new(article_repository, article_views_repository, double('ArticleContentRepository')) }
  let(:messages) { double('Messages') }
  let(:service) { described_class.new(unit_repository, messages) }
  let(:ip_address) { '127.0.1.1' }
  let(:article_id) { 1 }
  let(:current_time) { Time.now }

  before do
    allow(Time).to receive(:now).and_return(current_time)
  end

  describe '#update_views' do
    context 'when there are no previous views' do
      it 'creates a new view record and updates the article views count' do
        allow(article_views_repository).to receive(:get).and_return(nil)
        allow(article_views_repository).to receive(:next_id).and_return(1)
        allow(article_views_repository).to receive(:create).and_return(true)
        allow(article_repository).to receive(:update).and_return(true)
        allow(article_views_repository).to receive(:where).and_return(double(count: 1))

        expect(service.update_views(ip_address, article_id)).to be true
      end
    end

    context 'when creating a view record fails' do
      it 'raises a rollback error' do
        allow(article_views_repository).to receive(:get).and_return(nil)
        allow(article_views_repository).to receive(:next_id).and_return(1)
        allow(article_views_repository).to receive(:create).and_return(false)

        expect { service.update_views(ip_address, article_id) }.to raise_error(ActiveRecord::Rollback)
      end
    end

    context 'when updating the article views count fails' do
      it 'raises a rollback error' do
        allow(article_views_repository).to receive(:get).and_return(nil)
        allow(article_views_repository).to receive(:next_id).and_return(1)
        allow(article_views_repository).to receive(:create).and_return(true)
        allow(article_views_repository).to receive(:where).and_return(double(count: 1))
        allow(article_repository).to receive(:update).and_return(false)

        expect { service.update_views(ip_address, article_id) }.to raise_error(ActiveRecord::Rollback)
      end
    end
  end
end