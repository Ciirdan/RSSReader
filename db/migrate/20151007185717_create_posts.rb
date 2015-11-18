class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.datetime :published_at
      t.string :url
      t.boolean :status, :null => false, :default => false
      t.references :feed, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
