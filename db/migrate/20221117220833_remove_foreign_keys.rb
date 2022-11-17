class RemoveForeignKeys < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :parties, :users
    remove_foreign_key :actions, :users
  end
end
