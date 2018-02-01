######################################
# Script for populating the database #
######################################

alias Kakte.Repo
alias Kakte.Accounts.User

#########
# Users #
#########

# Basic user for testing the application
Repo.insert!(%User{
  username: "user",
  email: "user@kakte.io",
  password_hash: Comeonin.Bcrypt.hashpwsalt("password")
})

# More advanced profiles to test interactions

Repo.insert!(%User{
  username: "john",
  email: "john@smith.com",
  password_hash: Comeonin.Bcrypt.hashpwsalt("john"),
  fullname: "John Smith"
})

Repo.insert!(%User{
  username: "jean",
  email: "jean@dupont.fr",
  password_hash: Comeonin.Bcrypt.hashpwsalt("jean"),
  fullname: "Jean Dupont"
})
