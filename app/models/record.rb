class Record < ActiveRecord::Base
  belongs_to :location
  has_one :rain
  has_one :temperature
  has_one :wind

  scope :predicted_records, -> { where(type: 'PredictedRecord') }
  scope :actual_records, -> { where(type: nil) }

  class << self
    def new_with_unix_time(time)
      Record.new(time: Time.at(time).utc)
    end
  end
end
