class ArticleImages < ActiveRecord::Migration[7.1]
  def up
    create_table :article_images, :id => false do |t|
      t.integer :id
      t.integer :articleId
      t.string :imageURL
      t.integer :typeImage
      t.datetime :createdAt
    end
  end

  def down
    drop_table :article_views
  end
end
