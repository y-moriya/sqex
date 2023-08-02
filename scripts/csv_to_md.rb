require 'csv'

# CSVからデータを読み取り、セクションごとにグループ化する関数
def grouped_data_from_csv(file_name)
  data = {}
  CSV.foreach(file_name, headers: true) do |row|
    section = row['Section']
    title = row['Title']
    url = row['URL']

    data[section] ||= []
    data[section] << { title: title, url: url }
  end
  data
end

# グループ化されたデータからマークダウン形式で一覧を出力する関数
def generate_markdown(data)
  markdown = ""
  data.each do |section, items|
    markdown << "## #{section}\n"
    items.each do |item|
      markdown << "- [#{item[:title]}](#{item[:url]})\n"
    end
    markdown << "\n"
  end
  markdown
end

# 実行
data = grouped_data_from_csv('multi_playlists.csv')
markdown = generate_markdown(data)
puts markdown
