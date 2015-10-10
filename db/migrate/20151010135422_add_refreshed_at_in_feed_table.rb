class AddRefreshedAtInFeedTable < ActiveRecord::Migration
  def change
    add_column :feeds, :refreshed_at, :datetime
  end
end
