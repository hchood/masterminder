projects_attrs = [
  {
    name: "Lock up world oil supply",
    description: "Whaddya gonna do with your SUVs now, suckers!"
  },
  {
    name: "Tank the U.S. dollar"
  },
  {
    name: "Smite the world with plague of man-eating ladybugs",
    description: "You won't think they're so cute when they're munching on you."
  }
]

projects_attrs.each do |attrs|
  project = Project.find_by(attrs)

  if !project.nil?
    puts "Project '#{attrs[:name]}' already in database."
  else
    Project.create(attrs)
    puts "Project '#{attrs[:name]}' created."
  end
end
