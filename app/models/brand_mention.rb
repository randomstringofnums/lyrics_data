class BrandMention < ActiveRecord::Base
  belongs_to :brand
  belongs_to :track
  belongs_to :alt_brand_name 
end