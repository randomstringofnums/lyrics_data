class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.integer :album_mbid
      t.string :album_name
      t.integer :mxm_album_rating
      t.date :album_release_date
      t.string :first_primary_genre
    end

    add_index :albums, :id
    add_index :albums, :album_release_date
  end
end
