defmodule Hello.Accounts do
  @moduledoc """
  The Accounts context - handles all user-related operations.
  Think of this like a "UserService" in Node.js/Express.
  """

  alias Hello.Repo
  alias Hello.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
