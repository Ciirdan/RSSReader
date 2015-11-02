class AddPerPageToUser < ActiveRecord::Migration
  def change
    add_column :users, :per_page, :integer, :default => 25
  end
end
