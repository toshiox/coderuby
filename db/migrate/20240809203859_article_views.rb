class ArticleViews < ActiveRecord::Migration[7.1]
  def up
    create_table :article_views, :id => false do |t|
      t.integer :id
      t.integer :articleId
      t.string :ipAddress
      t.datetime :view_date
    end
  end

  def down
    drop_table :article_views
  end
end
