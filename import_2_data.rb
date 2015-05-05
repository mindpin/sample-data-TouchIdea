require 'yaml'
#has_and_belongs_to_many 

InfocardAppCategory.create(:title => '工具')
InfocardAppCategory.create(:title => '教育')
InfocardAppCategory.create(:title => '社区')
InfocardAppCategory.create(:title => '休闲')
InfocardAppCategory.create(:title => '游戏')

file_2_path = File.expand_path('../2.yaml', __FILE__)

yaml2 = YAML.load_file(file_2_path)
p "path #{file_2_path}"
count = yaml2.count
yaml2.each_with_index do |info,index|
  p "#{index+1}/#{count}"
  infocard_info = info["infocard"]

  infocard_app_categories = infocard_info['tag'].split(/,， /).map do |tag|
    InfocardAppCategory.where(:title => tag).first
  end

  infocard = Infocard.create(
    :kind  => Infocard::Kind::APP,
    :title => infocard_info['name'],
    :logo  => infocard_info['logo'],
    :homepage => infocard_info['site'],
    :desc     => infocard_info['desc'],
    :infocard_app_categories => infocard_app_categories
  )

  topic_info = infocard_info['topic']
  if !topic_info.nil?
    desc = topic_info["desc"]
    options = topic_info["options"]
    if desc.class == String && options.class == Array
      vote_items_attributes = options.map{|option| {:title => option}}
      User.first.votes.create(
        :infocard_id => infocard.id.to_s,
        :title => desc,
        :vote_items_attributes => vote_items_attributes
      )
    else
      raise "格式错误 #{infocard_info['name']}"
    end
  end
end