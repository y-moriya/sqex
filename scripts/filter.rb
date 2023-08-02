require 'csv'

# CSVファイルからタイトルとURLのペアのリストを読み取る関数
def extract_title_and_urls_from_csv(file_name)
  title_and_urls = []
  CSV.foreach(file_name, headers: true) do |row|
    title_and_urls << [row['Title'], row['URL']]
  end
  title_and_urls
end

# playlists.csvからタイトルとURLのペアを抽出
playlists_pairs = extract_title_and_urls_from_csv('playlists.csv')

# multi_playlists.csvからタイトルとURLのペアを抽出
multi_playlists_pairs = extract_title_and_urls_from_csv('multi_playlists.csv')

# playlists.csvに含まれ、multi_playlists.csvには含まれていないペアを見つける
unique_pairs = playlists_pairs - multi_playlists_pairs

# 結果のペアを出力
unique_pairs.each do |title, url|
  puts "Title: #{title}, URL: #{url}"
end
