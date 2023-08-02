require 'net/http'
require 'json'
require 'dotenv'
require 'csv'

Dotenv.load

API_KEY = ENV['YOUTUBE_API_KEY']
CHANNEL_ID = 'UCMx60HYcw1ieiPlZZagfqXQ'
BASE_URL = 'https://www.googleapis.com/youtube/v3'

def fetch_channel_sections(api_key, channel_id)
  uri = URI("#{BASE_URL}/channelSections")
  params = {
    part: 'snippet,contentDetails',
    channelId: channel_id,
    key: api_key,
    hl: 'ja'
  }
  uri.query = URI.encode_www_form(params)
  response = Net::HTTP.get_response(uri)
  JSON.parse(response.body)
end

def get_playlist_title_and_url(playlist_id)
  base_url = "https://www.googleapis.com/youtube/v3/playlists"
  uri = URI("#{base_url}?part=snippet&id=#{playlist_id}&key=#{API_KEY}&hl=ja")
  puts uri
  response = Net::HTTP.get(uri)
  data = JSON.parse(response)
  item = data['items'][0]

  if item
    title = item['snippet']['localized']['title']
    puts title
    url = "https://www.youtube.com/playlist?list=#{playlist_id}"
    [title, url]
  else
    [nil, nil]
  end
end

def main
  sections = fetch_channel_sections(API_KEY, CHANNEL_ID)
  multipleplaylists_section = sections['items'].select do |section|
    section['snippet'] && section['snippet']['type'] && section['snippet']['type'] == 'multipleplaylists'
  end

  if multipleplaylists_section.empty?
    puts "No 'multipleplaylists' type sections found."
    return
  end

  playlist_section_pairs = multipleplaylists_section.flat_map do |section|
    section['contentDetails']['playlists'].map { |id| [id, section['snippet']['title']] }
  end

  CSV.open("multi_playlists.csv", "wb") do |csv|
    csv << ["Title", "URL", "Section"]
    playlist_section_pairs.each do |id, section_title|
      title, url = get_playlist_title_and_url(id)
      csv << [title, url, section_title] if title && url
    end
  end
end

main
