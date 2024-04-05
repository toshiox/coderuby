class ArticleFormat
    def initialize
    end

    def remove_and_store_code_blocks(text)
      code_blocks = []

      text.gsub!(%r{<C#>(.*?)<\/C#>}m) do |match|
        code_blocks << match
        '<--C#-->'
      end

      text.gsub!(%r{<Ruby>(.*?)<\/Ruby>}m) do |match|
        code_blocks << match
        '<--RBY-->'
      end

      [text, code_blocks]
    end

    def restore_code_blocks(text, code_blocks)
      code_blocks.each do |code|
        if(text.include?('<--C#-->'))
          text = text.gsub('<--C#-->', code)
        elsif(text.include?('<--RBY-->'))
          text = text.gsub('<--RBY-->', code)
        end
      end
      text
    end

    def need_format(text)
      tags = /<(C#|Ruby)>/
      !text.scan(tags).empty?
    end
end
