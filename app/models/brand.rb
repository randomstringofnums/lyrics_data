require "i18n"
require 'uri'

I18n.enforce_available_locales = false

class Brand < ActiveRecord::Base
  has_many :brand_mentions
  has_one :excludable_brand
  has_many :alt_brand_names
  
  def url_safe_name
    name = I18n.transliterate(self.name).gsub("'s", "").
                                  gsub("'", "").
                                  gsub("-", " ").
                                  gsub(" ", "\%20").
                                  gsub("&", "\%26")
    '%20' + name
  end
  
  def excludable?
    [2,3].include?(self.excludable_brand.try(:score)) 
  end
end