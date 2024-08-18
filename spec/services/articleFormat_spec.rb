require 'rspec'
require_relative '../../app/services/utils/article_format'

RSpec.describe ArticleFormat do
  describe '#remove_and_store_code_blocks' do
    let(:article_format) { ArticleFormat.new }
    
    let(:service) { described_class.new }
    it 'removes and stores C# code blocks' do
      text = "<p>Some text</p><C#>puts 'Hello, C#'</C#>"

      result_text, result_code_blocks = article_format.remove_and_store_code_blocks(text)

      expect(result_text).to eq("<p>Some text</p><--C#-->")
      expect(result_code_blocks).to eq(["<C#>puts 'Hello, C#'</C#>"])
    end

    it 'removes and stores Ruby code blocks' do
      text = "<p>Some text</p><Ruby>puts 'Hello, Ruby'</Ruby>"

      result_text, result_code_blocks = article_format.remove_and_store_code_blocks(text)

      expect(result_text).to eq("<p>Some text</p><--RBY-->")
      expect(result_code_blocks).to eq(["<Ruby>puts 'Hello, Ruby'</Ruby>"])
    end

    it 'handles multiple code blocks' do
      text = "<p>Some text</p><C#>puts 'Hello, C#'</C#><Ruby>puts 'Hello, Ruby'</Ruby>"

      result_text, result_code_blocks = article_format.remove_and_store_code_blocks(text)

      expect(result_text).to eq("<p>Some text</p><--C#--><--RBY-->")
      expect(result_code_blocks).to eq(["<C#>puts 'Hello, C#'</C#>", "<Ruby>puts 'Hello, Ruby'</Ruby>"])
    end
  end
end