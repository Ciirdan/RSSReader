class CreateUserPosts < ActiveRecord::Migration
  def change
    create_table :user_posts do |t|
      t.references :user, index: true, foreign_key: true
      t.references :post, index: true, foreign_key: true
      t.boolean :favorited, :default => false, :null => false
      t.boolean :read, :default => false, :null => false

      t.timestamps null: false
    end

    remove_column :posts, :status
  end
end
