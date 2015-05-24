class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.decimal :long
      t.decimal :lat
      t.string :timezone
      t.belongs_to :post_code, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
