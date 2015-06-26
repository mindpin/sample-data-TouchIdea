require 'yaml'

file_3_path = File.expand_path('../3.yaml', __FILE__)

yaml3 = YAML.load_file(file_3_path)
p "path #{file_3_path}"
count = yaml3.count
yaml3.each_with_index do |info,index|
  p "#{index+1}/#{count}"

  desc = info["desc"]
  options = info["options"]

  if desc.class != String || options.class != Array
    next
  end
  vote_items_attributes = options.map{|opt|{:title => opt}}

  user = User.all[index%50]
  user.votes.create(
    :title => desc,
    :vote_items_attributes => vote_items_attributes
  )
end
