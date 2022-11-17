class CreateActions < ActiveRecord::Migration[7.0]
  def change
    create_table :actions do |t|
      t.column :action, :json

      t.references :user, null: false, foreign_key: true
      t.references :deal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
