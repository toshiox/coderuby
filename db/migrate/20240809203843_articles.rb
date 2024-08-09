class Articles < ActiveRecord::Migration[7.1]
  def up
    create_table :articles, :id => false do |t|
      t.integer :id
      t.string :title
      t.string :subtitle
      t.string :resume
      t.string :tags
      t.string :language
      t.integer :time_read
      t.integer :views
      t.datetime :created_at
    end
  end

  def down
    drop_table :articles
  end
end

