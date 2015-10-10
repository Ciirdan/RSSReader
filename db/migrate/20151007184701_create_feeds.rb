class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :title
      t.string :description
      t.string :site_url
      t.string :url

      t.timestamps null: false
    end
  end
end
