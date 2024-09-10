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

      text.gsub!(%r{<DockerFile>(.*?)<\/DockerFile>}m) do |match|
        code_blocks << match
        '<--DockerFile-->'
      end

      text.gsub!(%r{<DockerCompose>(.*?)<\/DockerCompose>}m) do |match|
        code_blocks << match
        '<--DockerCompose-->'
      end

      [text, code_blocks]
    end

    def restore_code_blocks(text, code_blocks)
      code_blocks.each_with_index do |code, index|
        if text.include?('<--C#-->')
          text.sub!('<--C#-->', code) if code.include?('<C#>')
        elsif text.include?('<--RBY-->')
          text.sub!('<--RBY-->', code) if code.include?('<Ruby>')
        end
      end
      text
    end

    def need_format(text)
      tags = /<(C#|Ruby|DockerFile|DockerCompose)>/
      !text.scan(tags).empty?
    end

    def dictionary(article_language, language_code)
      if(article_language == 'en')
        language_code == 'en' ? 'English' : 'Inglês'
      elsif(article_language == 'pt')
        language_code == 'en' ? 'Portuguese' : 'Português'
      else
        'Unknown'
      end
    end
end
