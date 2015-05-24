class CreateRains < ActiveRecord::Migration
  def change
    create_table :rains do |t|
      t.float :amount
      t.float :prob
      t.belongs_to :record, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
