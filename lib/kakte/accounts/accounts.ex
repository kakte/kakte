################################################################################
# kakte
# - A free web application to help film photographers manage their rolls of film
# Copyright (C) 2017 Jean-Philippe Cugnet <jean-philippe@cugnet.eu>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

defmodule Kakte.Accounts do
  @moduledoc """
  The context for accounts.
  """

  import Ecto.Query, warn: false

  alias Ecto.Changeset
  alias Kakte.Repo
  alias Kakte.Accounts.User

  @doc """
  Returns the list of users.
  """
  @spec list_users :: [User.t()]
  def list_users, do: Repo.all(User)

  @doc """
  Gets a user given its id or username.

  Raises `Ecto.NoResultsError` if the user does not exist.
  """
  @spec get_user!(pos_integer() | String.t()) :: User.t()
  def get_user!(id) when is_integer(id), do: Repo.get!(User, id)
  def get_user!(un) when is_binary(un), do: Repo.get_by!(User, username: un)

  @doc """
  Registers a user.
  """
  @spec register(map()) :: {:ok, User.t()} | {:error, Changeset.t()}
  def register(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  # @doc """
  # Updates a user.
  # """
  @spec update_user(User.t(), map()) ::
          {:ok, User.t()} | {:error, Changeset.t()}
  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()

    # TODO: Mettre à jour les sessions.
  end

  @doc """
  Deletes a User.
  """
  @spec delete_user(User.t()) :: {:ok, User.t()} | {:error, Changeset.t()}
  def delete_user(%User{} = user) do
    Expected.delete_all_user_logins(user.username)
    Repo.delete(user)
  end

  # @doc """
  # Returns an `%Ecto.Changeset{}` for tracking user changes.
  # """
  @spec change_user(User.t()) :: Changeset.t()
  def change_user(%User{} = user) do
    User.update_changeset(user, %{})
  end

  # @doc """
  # Returns an `%Ecto.Changeset{}` for tracking user registration changes.
  # """
  @spec change_user_registration(User.t()) :: Changeset.t()
  def change_user_registration(%User{} = user) do
    User.registration_changeset(user, %{})
  end
end
