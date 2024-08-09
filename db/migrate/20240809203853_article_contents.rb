class ArticleContents < ActiveRecord::Migration[7.1]
  def up
    create_table :article_contents, :id => false do |t|
      t.integer :id
      t.integer :articleId
      t.string :content
      t.datetime :createdAt
    end
  end

  def down
    drop_table :article_contents
  end
end