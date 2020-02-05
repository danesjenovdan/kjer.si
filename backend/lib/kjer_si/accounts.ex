defmodule KjerSi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias KjerSi.Repo

  alias KjerSi.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Checks if nickname is unique.
  """
  def unique_nickname?(nickname) do
    nil == Repo.get_by(User, nickname: nickname)
  end

  @doc """
  Gets a single user by uid.

  Returns `nil` if the User does not exist.

  ## Examples

      iex> get_user!('asdf')
      %User{}

      iex> get_user!('fdsa')
      ** nil

  """
  def get_user_by_uid(uid), do: Repo.get_by(User, uid: uid)

  @doc """
  Gets a single user by id and preloads stuff.

  Returns `nil` if the User does not exist.

  ## Examples

      iex> get_user!('asdf')
      %User{}

      iex> get_user!('fdsa')
      ** nil

  """
  def get_user_with_preload(uid, preload) do
    uid
    |> get_user!
    |> Repo.preload(preload)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias KjerSi.Accounts.UserRoom

  @doc """
  Returns the list of user rooms.

  ## Examples

      iex> list_user_rooms()
      [%UserRoom{}, ...]

  """
  def list_user_rooms do
    Repo.all(UserRoom)
  end

  @doc """
  Returns the list of user rooms.

  ## Examples

      iex> list_user_rooms()
      [%UserRoom{}, ...]

  """
  def list_user_rooms_by_user(user) do
    Repo.all(from ur in UserRoom, where: ur.user_id == ^user.id, select: ur)
  end

  @doc """
  Subscribes user to room.

  ## Examples

      iex> create_user_room(%{field: value})
      {:ok, %UserRoom{}}

      iex> create_user_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_room(attrs \\ %{}) do
    %UserRoom{}
    |> UserRoom.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a single user_room.

  Raises `Ecto.NoResultsError` if the UserRoom does not exist.

  ## Examples

      iex> get_user_room!(123)
      %User{}

      iex> get_user_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_room!(id), do: Repo.get!(UserRoom, id)

  @doc """
  Unsubscribes user from room.

  ## Examples

      iex> delete_user_room(user_room)
      {:ok, %UserRoom{}}

      iex> delete_user_room(user_room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_room(%UserRoom{} = user_room) do
    Repo.delete(user_room)
  end
end
