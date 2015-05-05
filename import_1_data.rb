require 'yaml'
require 'uri'

file_1_path = File.expand_path('../1.yaml', __FILE__)

yaml1 = YAML.load_file(file_1_path)
p "path #{file_1_path}"
count = yaml1.count
yaml1.each_with_index do |info,index|
  p "#{index+1}/#{count}"
  url = info["url"]
  URI.parse(URI.encode(url))

  infocard = Infocard.parse(url)

  desc = info['desc']
  options = info['options']

  if !desc.nil?
    if desc.class == String && options.class == Array
      vote_items_attributes = options.map{|option| {:title => option}}
      User.first.votes.create(
        :infocard_id => infocard.id.to_s,
        :title => desc,
        :vote_items_attributes => vote_items_attributes
      )
    else
      raise "错误数据 #{url}"
    end
  end
end
