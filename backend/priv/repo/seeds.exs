# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     KjerSi.Repo.insert!(%KjerSi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Generate users
KjerSi.Repo.insert!(%KjerSi.Accounts.User{uid: "1", nickname: "Polde"})
KjerSi.Repo.insert!(%KjerSi.Accounts.User{uid: "2", nickname: "Micka"})
KjerSi.Repo.insert!(%KjerSi.Accounts.User{uid: "3", nickname: "Štef"})

# Generate room categories
kultura = KjerSi.Repo.insert!(%KjerSi.Rooms.Category{name: "Kultura"})
sport = KjerSi.Repo.insert!(%KjerSi.Rooms.Category{name: "Šport"})
KjerSi.Repo.insert!(%KjerSi.Rooms.Category{name: "Živali"})

# Generate rooms
KjerSi.Repo.insert!(%KjerSi.Rooms.Room{
  name: "Lokalni koncerti",
  category: kultura,
  lat: 13.0,
  lng: 15.0,
  radius: 2500
})

KjerSi.Repo.insert!(%KjerSi.Rooms.Room{
  name: "Pevski zbor",
  category: kultura,
  lat: 13.0,
  lng: 15.0,
  radius: 2500
})

KjerSi.Repo.insert!(%KjerSi.Rooms.Room{
  name: "Gre kdo basket?",
  category: sport,
  lat: 13.0,
  lng: 15.0,
  radius: 2500
})
