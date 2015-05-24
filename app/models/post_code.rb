class PostCode < ActiveRecord::Base
  has_many :locations
end
