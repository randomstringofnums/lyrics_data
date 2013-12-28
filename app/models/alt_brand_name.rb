class AltBrandName < ActiveRecord::Base
  belongs_to :brand
  has_many :brand_mentions
  
  def url_safe_name
    name = I18n.transliterate(self.name).gsub("'s", "").
                                  gsub("'", "").
                                  gsub("-", " ").
                                  gsub(" ", "\%20").
                                  gsub("&", "\%26")
    '%20' + name
  end
end