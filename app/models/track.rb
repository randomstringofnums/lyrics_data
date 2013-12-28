class Track < ActiveRecord::Base
  has_many :brand_mentions
  belongs_to :album
  has_one :deduped_track
end