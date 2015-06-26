require 'yaml'
require 'uri'

file_1_path = File.expand_path('../1.yaml', __FILE__)

yaml1 = YAML.load_file(file_1_path)
p "path #{file_1_path}"
count = yaml1.count
infocard_error = []
yaml1.each_with_index do |info,index|
  p "#{index+1}/#{count}"
  url = info["url"]
  URI.parse(URI.encode(url))

  begin
    infocard = Infocard.parse(url)
  rescue
    infocard_error << url
    next
  end
  if infocard.nil?
    infocard_error << url
    next
  end

  desc = info['desc']
  options = info['options']

  if Vote.where(:infocard_id => infocard.id.to_s).count != 0
    next
  end

  if !desc.nil?

    if desc.class != String || options.class != Array
      next
    end
    vote_items_attributes = options.map{|option| {:title => option}}

  else
    desc = '这是我的购物分享，说说你的看法吧！'
    vote_items_attributes = []
  end

  vote_items_attributes << {title: 'SYSTEM:GOOD'}
  vote_items_attributes << {title: 'SYSTEM:SOSO'}
  vote_items_attributes << {title: 'SYSTEM:BAD'}

  user = User.all[index%50]
  user.votes.create(
    :infocard_id => infocard.id.to_s,
    :title => desc,
    :vote_items_attributes => vote_items_attributes
  )
end

p "导入完成"
if infocard_error.count == 0
  p "全部导入成功"
else
  p "有一些导入失败"
  p infocard_error
end
