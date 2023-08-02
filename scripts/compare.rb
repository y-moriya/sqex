def extract_markdown_pairs(filename)
  pairs = []
  File.readlines(filename).each do |line|
    # 正規表現を使用して "- [Title](URL)" 形式の行を解析
    match_data = line.match(/\-\s+\[(.*?)\]\((.*?)\)/)
    if match_data
      title = match_data[1]
      url = match_data[2]
      pairs << { title: title, url: url }
    end
  end
  pairs
end

def unique_pairs_from_a(a_pairs, b_pairs)
  a_pairs - b_pairs
end

# マークダウンファイルからペアを抽出
a_md_pairs = extract_markdown_pairs('playlists.md')
b_md_pairs = extract_markdown_pairs('tmp.md')

# A.md にのみ存在するペアを取得
unique_to_a = unique_pairs_from_a(a_md_pairs, b_md_pairs)

# 結果を出力
unique_to_a.each do |pair|
  puts "- [#{pair[:title]}](#{pair[:url]})"
end
