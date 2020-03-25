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
polde =
  KjerSi.Repo.insert!(%KjerSi.Accounts.User{uid: "1", nickname: "Polde the Admin", is_admin: true})

micka = KjerSi.Repo.insert!(%KjerSi.Accounts.User{uid: "2", nickname: "Micka"})
stef = KjerSi.Repo.insert!(%KjerSi.Accounts.User{uid: "3", nickname: "Štef"})

# Generate room categories
druzenje = KjerSi.Repo.insert!(%KjerSi.Rooms.Category{name: "SOCIAL"})
sport = KjerSi.Repo.insert!(%KjerSi.Rooms.Category{name: "RECREATION"})
pomoc = KjerSi.Repo.insert!(%KjerSi.Rooms.Category{name: "HELP"})

# Generate rooms
ljubitelji_psov =
  KjerSi.Repo.insert!(
    KjerSi.Rooms.Room.changeset(%KjerSi.Rooms.Room{}, %{
      name: "Ljubitelji psov",
      category_id: pomoc.id,
      lat: 13.0,
      lng: 15.0,
      radius: 2500,
      description: "Tukaj se zmenimo za skupne sprehode z našimi kosmatinci"
    })
  )

pevski_zbor =
  KjerSi.Repo.insert!(
    KjerSi.Rooms.Room.changeset(%KjerSi.Rooms.Room{}, %{
      name: "Pevski zbor",
      category_id: druzenje.id,
      lat: 13.0,
      lng: 15.0,
      radius: 2500,
      description: "Ženska vokalna skupina Marjetice vabi vse pevke v svojo sredino"
    })
  )

gre_kdo_basket =
  KjerSi.Repo.insert!(
    KjerSi.Rooms.Room.changeset(%KjerSi.Rooms.Room{}, %{
      name: "Gre kdo basket?",
      category_id: sport.id,
      lat: 13.0,
      lng: 15.0,
      radius: 2500,
      description: "Ponavadi ob četrtkih zvečer, na igrišču pri osnovni šoli"
    })
  )

# Generate subscriptions
KjerSi.Repo.insert!(%KjerSi.Accounts.Subscription{user: polde, room: ljubitelji_psov})
KjerSi.Repo.insert!(%KjerSi.Accounts.Subscription{user: polde, room: pevski_zbor})
KjerSi.Repo.insert!(%KjerSi.Accounts.Subscription{user: polde, room: gre_kdo_basket})

KjerSi.Repo.insert!(%KjerSi.Accounts.Subscription{user: micka, room: ljubitelji_psov})
KjerSi.Repo.insert!(%KjerSi.Accounts.Subscription{user: stef, room: ljubitelji_psov})

# Generate messages
KjerSi.Repo.insert!(%KjerSi.Messages.Message{
  content: "kako ste?",
  room: ljubitelji_psov,
  user: polde
})

KjerSi.Repo.insert!(%KjerSi.Messages.Message{
  content: "gre kdo na sprehod?",
  room: ljubitelji_psov,
  user: polde
})

KjerSi.Repo.insert!(%KjerSi.Messages.Message{
  content: "ja, čez 5 minut",
  room: ljubitelji_psov,
  user: micka
})

# Generate event
bakanje_event =
  KjerSi.Repo.insert!(
    KjerSi.Events.Event.changeset(%KjerSi.Events.Event{}, %{
      name: "tu se baka",
      datetime: "2019-11-30 12:12:12",
      location: "Lokacija",
      description: "description",
      max_attending: "2",
      user_id: micka.id,
      room_id: pevski_zbor.id
    })
  )

# Generate event subscriptions
KjerSi.Repo.insert!(%KjerSi.Events.UserEvent{user: polde, event: bakanje_event})
KjerSi.Repo.insert!(%KjerSi.Events.UserEvent{user: micka, event: bakanje_event})
KjerSi.Repo.insert!(%KjerSi.Events.UserEvent{user: stef, event: bakanje_event})
