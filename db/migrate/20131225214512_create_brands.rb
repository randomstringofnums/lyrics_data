class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name
      t.integer :interbrand_rank_2013
      t.integer :interbrand_rank_2012
      t.string :interbrand_country
      t.string :interbrand_sector
    end
  end
end
