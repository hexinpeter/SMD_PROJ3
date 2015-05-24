class Record < ActiveRecord::Base
  belongs_to :location
  scope :predicted_records, -> { where(type: 'PredictedRecord') }
  scope :actual_records, -> { where(type: nil) }

end
