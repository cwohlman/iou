class CreateActions < ActiveRecord::Migration[7.0]
  def change
    create_table :actions do |t|
      t.string :transactionId
      t.integer :revisionNumber
      t.references :partyA, null: false, foreign_key: true
      t.references :partyB, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: true
      t.datetime :timestamp
      t.json :action

      t.timestamps
    end
  end
end
