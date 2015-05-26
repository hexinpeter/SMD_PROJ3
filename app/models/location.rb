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

  def last_update
    latest = actual_records.order(time).last
    latest ? latest.time.strftime('%H:%M%p %d-%m-%Y').downcase : 'N/A'
  end

  private
    def Location.generate_ref_code
      max_ref_code = Location.any? ? Location.order(:ref_code).last.ref_code : nil
      max_ref_code ? max_ref_code + 1 : 10000
    end
end
