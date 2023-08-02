require 'net/http'
require 'json'
require 'csv'
require 'dotenv'

Dotenv.load

API_KEY = ENV['YOUTUBE_API_KEY']
CHANNEL_ID = 'UCMx60HYcw1ieiPlZZagfqXQ'
BASE_URL = 'https://www.googleapis.com/youtube/v3/playlists'
OUTPUT_FILE = 'playlists.csv'

def fetch_playlists(api_key, channel_id, page_token = nil)
  uri = URI(BASE_URL)
  params = {
    part: 'snippet',
    channelId: channel_id,
    maxResults: 50,
    key: api_key
  }
  params.merge!(pageToken: page_token) if page_token

  uri.query = URI.encode_www_form(params)
  response = Net::HTTP.get_response(uri)
  JSON.parse(response.body)
end

def main
  playlists = []

  page_token = nil
  loop do
    data = fetch_playlists(API_KEY, CHANNEL_ID, page_token)
    data['items'].each do |item|
      playlists << {
        'title' => item['snippet']['title'],
        'url' => "https://www.youtube.com/playlist?list=#{item['id']}"
      }
    end
    page_token = data['nextPageToken']
    break unless page_token
  end

  CSV.open(OUTPUT_FILE, 'w') do |csv|
    csv << ['Title', 'URL']
    playlists.each do |playlist|
      csv << [playlist['title'], playlist['url']]
    end
  end

  puts "#{playlists.size} playlists saved to #{OUTPUT_FILE}"
end

main
