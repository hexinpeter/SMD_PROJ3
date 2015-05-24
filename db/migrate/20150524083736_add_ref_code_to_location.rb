class AddRefCodeToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :ref_code, :integer
  end
end
