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

defmodule Kakte.Accounts.User do
  @moduledoc """
  The schema for users.
  """

  use Ecto.Schema
  use Timex.Ecto.Timestamps

  import Ecto.Changeset

  alias Ecto.Changeset

  @typedoc "An event"
  @type t :: %__MODULE__{
    id: pos_integer | nil,
    username: String.t,
    email: String.t,
    password: nil,
    password_hash: String.t,
    fullname: String.t | nil,
    inserted_at: Calendar.datetime | nil,
    updated_at: Calendar.datetime | nil,
  }

  @fields [
    :username,
    :email,
    :password,
    :fullname,
  ]

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :fullname, :string

    timestamps()
  end

  @doc """
  Changeset for user registration.
  """
  @spec registration_changeset(%__MODULE__{}, map) :: Changeset.t
  def registration_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @fields)
    |> validate_required(~w(username email password)a)
    |> validate_changes
  end

  @doc """
  Changeset for user update.
  """
  @spec update_changeset(t, map) :: Changeset.t
  def update_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @fields)
    |> validate_required(~w(username email)a)
    |> validate_changes
  end

  @spec validate_changes(Changeset.t) :: Changeset.t
  defp validate_changes(%Changeset{} = changeset) do
    changeset
    |> validate_format(:email, ~r/@/)
    |> validate_password_strength
    |> validate_confirmation(:password)
    |> hash_password
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end

  @spec validate_password_strength(Changeset.t) :: Changeset.t
  defp validate_password_strength(%Changeset{valid?: true, changes:
    %{password: password}} = changeset) do
    case NotQwerty123.PasswordStrength.strong_password?(password) do
      {:ok, _}          -> changeset
      {:error, message} -> add_error(changeset, :password, message)
    end
  end
  defp validate_password_strength(changeset), do: changeset

  @spec hash_password(Changeset.t) :: Changeset.t
  defp hash_password(%Changeset{valid?: true, changes:
      %{password: password}} = changeset) do
    change(changeset, Comeonin.Bcrypt.add_hash(password))
  end
  defp hash_password(changeset), do: changeset
end
