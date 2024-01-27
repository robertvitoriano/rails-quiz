Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |seed|
  load seed
end
User.create({name:"Robert Admin", username: "ADMrobert", password:'123'})
