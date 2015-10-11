class CreateUserPosts < ActiveRecord::Migration
  def change
    create_table :user_posts do |t|
      t.references :user, index: true, foreign_key: true
      t.references :post, index: true, foreign_key: true
      t.boolean :favorited, :default => 0, :null => false
      t.boolean :read, :default => 0, :null => false

      t.timestamps null: false
    end

    remove_column :posts, :status
  end
end
