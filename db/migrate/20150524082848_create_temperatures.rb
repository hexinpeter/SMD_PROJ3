class CreateTemperatures < ActiveRecord::Migration
  def change
    create_table :temperatures do |t|
      t.float :value
      t.float :dew_point
      t.float :prob
      t.belongs_to :record, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
