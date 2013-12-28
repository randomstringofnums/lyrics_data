require File.expand_path('../../../config/boot',  __FILE__)
require File.expand_path('../../../config/environment',  __FILE__)
require 'unirest'
require 'active_support/all'
require 'require_all'
require_all File.expand_path('../../../app/models',  __FILE__)

def get_album(album_id)
  url = "http://api.musixmatch.com/ws/1.1/album.get?"
  response = Unirest.get(url,
                parameters: {apikey: MXM_API.fetch('key'),
                             album_id: album_id
                })
  response.body.fetch('message').fetch('body').fetch('album')
end

def add_album(album)
  first_primary_genre = album.fetch("primary_genres").
                              fetch("music_genre_list").
                              try(:first).
                              try(:fetch, "music_genre").
                              try(:fetch, "music_genre_name_extended")
  
  Album.where(:id => album.fetch('album_id')).first_or_create(
    id: album.fetch('album_id'),
    album_mbid: album.fetch('album_mbid'),
    album_name: album.fetch('album_name'),
    mxm_album_rating: album.fetch('album_rating'),
    album_release_date: album.fetch('album_release_date'),
    first_primary_genre: first_primary_genre      
  )
end

Track.where('mxm_track_rating > 31').each do |track|
  if track.deduped_track.present? && Album.find(track.album_id).nil?
    album = get_album(track.album_id)
    add_album(album)
  end
end