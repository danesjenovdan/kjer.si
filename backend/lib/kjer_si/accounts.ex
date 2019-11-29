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
  Gets a single user by uuid.

  Returns `nil` if the User does not exist.

  ## Examples

      iex> get_user!('asdf')
      %User{}

      iex> get_user!('fdsa')
      ** nil

  """
  def get_user_by_uuid(uuid), do: Repo.get_by(User, uuid: uuid)

  @doc """
  Checks if a user is an admin.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!('asdf')
      %User{}

      iex> get_user!('fdsa')
      ** (Ecto.NoResultsError)

  """
  def is_admin(uuid) do
    user = Repo.get_by(User, uuid: uuid)
    if user do
      user.is_admin
    else
      false
    end
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

  alias KjerSi.Accounts.UserChannel

  @doc """
  Returns the list of user channels.

  ## Examples

      iex> list_user_channels()
      [%UserChannel{}, ...]

  """
  def list_user_channels do
    Repo.all(UserChannel)
  end

  @doc """
  Subscribes user to channel.

  ## Examples

      iex> create_user_channel(%{field: value})
      {:ok, %UserChannel{}}

      iex> create_user_channel(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_channel(attrs \\ %{}) do
    %UserChannel{}
    |> UserChannel.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Unsubscribes user from channel.

  ## Examples

      iex> delete_user_channel(user_channel)
      {:ok, %UserChannel{}}

      iex> delete_user_channel(user_channel)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_channel(%UserChannel{} = user_channel) do
    Repo.delete(user_channel)
  end
end
