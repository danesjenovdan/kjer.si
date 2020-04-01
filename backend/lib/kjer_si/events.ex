defmodule KjerSi.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false

  alias KjerSi.Repo
  alias KjerSi.Events.Event
  alias KjerSi.Events.UserEvent

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Gets a single event by id.

  Returns `nil` if the Event does not exist.

  ## Examples

      iex> get_event!('asdf')
      %Event{}

      iex> get_event!('fdsa')
      ** nil

  """
  def get_event_by_id(id), do: Repo.get_by(Event, id: id)

  @doc """
  Checks if a event is an admin.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!('asdf')
      %Event{}

      iex> get_event!('fdsa')
      ** (Ecto.NoResultsError)

  """
  def is_admin(uuid) do
    event = Repo.get_by(Event, uuid: uuid)
    if event do
      event.is_admin
    else
      false
    end
  end

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changesetUpdate(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end

  @doc """
  Returns the list of user events.

  ## Examples

      iex> list_user_events()
      [%UserEvent{}, ...]

  """
  def list_user_events do
    Repo.all(UserEvent)
  end

  @doc """
  Subscribes user to event.

  ## Examples

      iex> create_user_event(%{field: value})
      {:ok, %UserEvent{}}

      iex> create_user_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_event(attrs \\ %{}) do
    %UserEvent{}
    |> UserEvent.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Unsubscribes user from event.

  ## Examples

      iex> delete_user_event(user_event)
      {:ok, %UserEvent{}}

      iex> delete_user_event(user_event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_event(%UserEvent{} = user_event) do
    Repo.delete(user_event)
  end

  @doc """
  Gets a single event.
  Raises `Ecto.NoResultsError` if the UserEvent does not exist.
  ## Examples
      iex> get_user_event!(123)
      %User{}
      iex> get_user_event!(456)
      ** (Ecto.NoResultsError)
  """
  def get_user_event!(uuid), do: Repo.get!(UserEvent, uuid)

  def get_events_of_user(user) do
    Repo.all(from ur in UserEvent, where: ur.user_id == ^user.id, select: ur)
  end

end
