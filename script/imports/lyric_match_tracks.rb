require File.expand_path('../../../config/boot',  __FILE__)
require File.expand_path('../../../config/environment',  __FILE__)
require 'unirest'
require 'active_support/all'
require 'require_all'
require_all File.expand_path('../../../app/models',  __FILE__)

def match_brand_tracks(brand, alt_brand_name = nil)
  url_safe_brand_name = (alt_brand_name.nil? ? brand.url_safe_name : alt_brand_name.url_safe_name)
  tracks = [0] * 100
  page_counter = 1
  until tracks.size < 99 || page_counter > 10 # all tracks requested (API request returns < 99) or 1000 most popular tracks
    tracks = get_tracks(url_safe_brand_name, page_counter)
    tracks.each do |track_data|
      track = track_data.fetch('track')
      track_id = track.fetch('track_id')
      add_track(track)
      add_brand_mention(track_id, brand.id, alt_brand_name.try(:id))
    end
    page_counter += 1
  end
end

def get_tracks(url_safe_brand_name, page)
  url = "http://api.musixmatch.com/ws/1.1/track.search?q_lyrics=%s" % url_safe_brand_name
  response = Unirest.get(url,
                parameters: {apikey: MXM_API.fetch('key'),
                             page_size: 100,
                             f_lyrics_language: 'en',
                             s_track_rating: 'desc', # sort by track popularity index
                             page: page
                })
  response.body.fetch('message').fetch('body').fetch('track_list')
end

def add_track(track)
  Track.where(:id => track.fetch('track_id')).first_or_create(
    id: track.fetch('track_id'),
    track_mbid: track.fetch('track_mbid'),
    track_name: track.fetch('track_name'),
    mxm_track_rating: track.fetch('track_rating'),
    track_length: track.fetch('track_length'),
    album_id: track.fetch('album_id'),
    album_name: track.fetch('album_id'),
    artist_id: track.fetch('artist_id'),
    artist_name: track.fetch('artist_name'),
    photo_link: track.fetch('album_coverart_100x100')        
  )
end

def add_brand_mention(track_id, brand_id, alt_brand_name_id = nil)
# add brand mentions if new track/brand pair, full brand name has priority over alt brand name matches
  BrandMention.where(track_id: track_id, :brand_id => brand_id).first_or_create(
    brand_id: brand_id,
    track_id: track_id,
    alt_brand_name_id: alt_brand_name_id       
  )
end

Brand.all.each do |brand|
  match_brand_tracks(brand) if !brand.excludable?
  AltBrandName.where(:brand_id => brand.id).each do |alt_brand_name|
    match_brand_tracks(brand, alt_brand_name)
  end
end



