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
    User
    |> where([u], u.is_admin == false)
    |> Repo.all
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
  Gets a single user.

  Returns `nil` if the User does not exist.

  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Checks if nickname is unique.
  """
  def unique_nickname?(nickname) do
    nil == Repo.get_by(User, nickname: nickname)
  end

  @doc """
  Gets a single user by uid.

  Returns `nil` if the User does not exist.

  """
  def get_user_by_uid(uid), do: Repo.get_by(User, uid: uid)

  @doc """
  Gets a single user by id and preloads stuff.

  Returns `nil` if the User does not exist.

  """
  def get_user_with_preload(id, preload) do
    id
    |> get_user
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
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias KjerSi.Accounts.Subscription

  @doc """
  Returns a list of subscriptions for given user id

  ## Examples

      iex> list_subscriptions(user_id)
      [%Subscription{}, ...]

  """
  def list_subscriptions(user_id) do
    Repo.all(from Subscription, where: [user_id: ^user_id])
  end

  @doc """
  Subscribes user to room.

  ## Examples

      iex> create_subscription(%{field: value})
      {:ok, %Subscription{}}

      iex> create_subscription(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subscription(attrs \\ %{}) do
    %Subscription{}
    |> Subscription.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a single subscription.

  Raises `Ecto.NoResultsError` if the Subscription does not exist.

  ## Examples

      iex> get_subscription!(123)
      %User{}

      iex> get_subscription!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subscription!(id), do: Repo.get!(Subscription, id)

  @doc """
  Gets a single subscription.

  ## Examples

      iex> get_subscription(123)
      {:ok, %Subscription{}}

      iex> get_subscription(456)
      {:error, :not_found}

  """
  def get_subscription(id) do
    case Repo.get(Subscription, id) do
      nil -> {:error, :not_found}
      subscription -> {:ok, subscription}
    end
  end

  @doc """
  Unsubscribes user from room.

  ## Examples

      iex> delete_subscription(subscription)
      {:ok, %Subscription{}}

      iex> delete_subscription(subscription)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subscription(%Subscription{} = subscription) do
    Repo.delete(subscription)
  end
end
