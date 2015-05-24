class CreateWinds < ActiveRecord::Migration
  def change
    create_table :winds do |t|
      t.string :dir
      t.float :speed
      t.float :prob
      t.belongs_to :record, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
