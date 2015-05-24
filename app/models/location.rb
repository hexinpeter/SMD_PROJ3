class Location < ActiveRecord::Base
  belongs_to :post_code
  has_many :records

  delegate :predicted_records, :actual_records, to: :records
end
