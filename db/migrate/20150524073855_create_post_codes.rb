class CreatePostCodes < ActiveRecord::Migration
  def change
    create_table :post_codes do |t|
      t.string :num

      t.timestamps null: false
    end
  end
end
