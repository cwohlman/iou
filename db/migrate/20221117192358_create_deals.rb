class CreateDeals < ActiveRecord::Migration[7.0]
  def change
    create_table :deals do |t|
      t.text :comment

      t.timestamps
    end
    create_table :parties do |t|
      t.references :user, null: false, foreign_key: true
      t.references :deal, null: false, foreign_key: true
    end
  end
end

