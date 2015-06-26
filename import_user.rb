(1..50).each do |index|
  User.create!(
    :uid         => index,
    :nickname    => "yunying#{index}",
    :avatar_url  => "http://i.teamkn.com/i/bcfWnZG2.png",
    :gender      => "m",
    :location    => "北京",
    :description => "运营专员#{index}"
  )
end
