class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.datetime :time
      t.string :condition
      t.string :type
      t.belongs_to :location, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
