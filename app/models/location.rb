class Location < ActiveRecord::Base
  belongs_to :post_code
  has_many :records

  delegate :predicted_records, :actual_records, to: :records

  def Location.create_without_ref_code(params={})
    loc = Location.new(params)
    loc.ref_code = generate_ref_code
    loc.save!
    loc
  end

  def Location.new_without_ref_code(params={})
    loc = Location.new(params)
    loc.ref_code = generate_ref_code
    loc
  end

  private
    def Location.generate_ref_code
      Location.order(:ref_code).last.ref_code ? Location.order(:ref_code).last.ref_code + 1 : 10000
    end
end
