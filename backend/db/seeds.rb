user_attrs = [
  {
    first_name: "Faizaan",
    last_name: "The Wizard",
    email: "wiz@nefariousschemers.com",
    password: "secretschemes",
    bio: "I am an evil wizard."
  },
  {
    first_name: "Gob",
    last_name: "Bluth",
    email: "gob@ivemadeahugetinymistake.com",
    password: "bananastand",
    bio: "It's an illusion, Michael."
  }
]

projects_attrs = [
  {
    user_email: "wiz@nefariousschemers.com",
    name: "Lock up world oil supply",
    description: "Whaddya gonna do with your SUVs now, suckers!",
    tasks: [
      { name: "Assemble minions" },
      { name: "Take over OPEC" },
      { name: "Jack up prices" }
    ]
  },
  {
    user_email: "wiz@nefariousschemers.com",
    name: "Tank the U.S. dollar",
    tasks: []
  },
  {
    user_email: "wiz@nefariousschemers.com",
    name: "Smite the world with plague of man-eating ladybugs",
    description: "You won't think they're so cute when they're munching on you.",
    tasks: [
      { name: "Genetically modify ladybugs" },
      { name: "Release them on the world" },
      { name: "Monitor destruction" }
    ]
  }
]

user_attrs.each do |attrs|
  user = User.find_by(email: attrs[:email] )

  if user.present?
    puts "User #{attrs[:first_name]} #{attrs[:last_name]} already in database."
  else
    User.create(attrs)
    puts "User '#{attrs[:first_name]} #{attrs[:last_name]}' created."
  end
end

projects_attrs.each do |attrs|
  user = User.find_by(email: attrs[:user_email])
  project = Project.find_by(user: user, name: attrs[:name])

  if project.present?
    puts "Project '#{attrs[:name]}' already in database."
  else
    project = Project.create(
      user: user,
      name: attrs[:name],
      description: attrs[:description]
    )

    attrs[:tasks].each do |task_attrs|
      task = project.tasks.build(task_attrs)
      task.save!
    end

    puts "Project '#{attrs[:name]}' created."
  end
end
