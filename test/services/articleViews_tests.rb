require 'rspec'
require_relative '../../app/repositories/unit_repository.rb'
require_relative '../../app/services/articleViews_service.rb'

RSpec.describe ArticleViewsService do
  let(:service) { ArticleViewsService.new }
  let(:unit) { UnitRepository.new }

  describe '#updateViews' do
    context 'when IP address is not localhost and no views in the last 12 hours' do
      let(:ip_address) { '192.168.1.1' }
      let(:article_id) { '654a44012bd6ebb1202d3c77' }

      before do
        allow(unit.articleViews).to receive(:any).and_return(false)
        allow(unit.articleViews).to receive(:find_and_upsert).and_return(true)
        allow(unit.articleViews).to receive_message_chain(:find, :count).and_return(5)
        allow(unit.article).to receive(:update)
      end

      it 'updates views' do
        expect(unit.articleViews).to receive(:any).with(hash_including('articleId' => article_id)).and_return(false)
        expect(unit.articleViews).to receive(:find_and_upsert).with(hash_including('articleId' => article_id)).and_return(true)
        expect(unit.articleViews).to receive(:find).with(hash_including('articleId' => article_id)).and_return(double(count: 5))
        expect(unit.article).to receive(:update).with(hash_including('id' => article_id), hash_including('$set' => { 'views' => 5 }))

        service.updateViews(ip_address, article_id)
      end
    end

    # Adicione mais contextos e exemplos para outros cenários de teste
  end
end
