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
polde = KjerSi.Repo.insert!(%KjerSi.Accounts.User{uid: "1", nickname: "Polde the Admin", is_admin: true})
micka = KjerSi.Repo.insert!(%KjerSi.Accounts.User{uid: "2", nickname: "Micka"})
stef = KjerSi.Repo.insert!(%KjerSi.Accounts.User{uid: "3", nickname: "Štef"})

# Generate room categories
kultura = KjerSi.Repo.insert!(%KjerSi.Rooms.Category{name: "Kultura"})
sport = KjerSi.Repo.insert!(%KjerSi.Rooms.Category{name: "Šport"})
zivali = KjerSi.Repo.insert!(%KjerSi.Rooms.Category{name: "Živali"})

# Generate rooms
ljubitelji_psov = KjerSi.Repo.insert!(KjerSi.Rooms.Room.changeset(%KjerSi.Rooms.Room{}, %{
  name: "Ljubitelji psov",
  category_id: zivali.id,
  lat: 13.0,
  lng: 15.0,
  radius: 2500
}))

pevski_zbor = KjerSi.Repo.insert!(KjerSi.Rooms.Room.changeset(%KjerSi.Rooms.Room{}, %{
  name: "Pevski zbor",
  category_id: kultura.id,
  lat: 13.0,
  lng: 15.0,
  radius: 2500
}))

gre_kdo_basket = KjerSi.Repo.insert!(KjerSi.Rooms.Room.changeset(%KjerSi.Rooms.Room{}, %{
  name: "Gre kdo basket?",
  category_id: sport.id,
  lat: 13.0,
  lng: 15.0,
  radius: 2500
}))

# Generate subscriptions
KjerSi.Repo.insert! %KjerSi.Accounts.UserRoom{user: polde, room: ljubitelji_psov}
KjerSi.Repo.insert! %KjerSi.Accounts.UserRoom{user: polde, room: pevski_zbor}
KjerSi.Repo.insert! %KjerSi.Accounts.UserRoom{user: polde, room: gre_kdo_basket}

KjerSi.Repo.insert! %KjerSi.Accounts.UserRoom{user: micka, room: ljubitelji_psov}
KjerSi.Repo.insert! %KjerSi.Accounts.UserRoom{user: stef, room: ljubitelji_psov}
