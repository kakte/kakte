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

defmodule KakteWeb.Auth do
  @moduledoc """
  Module for connection authentication.
  """

  import Plug.Conn, only: [assign: 3, get_session: 2]

  alias Kakte.Accounts.User
  alias Kakte.Repo
  alias Comeonin.Bcrypt

  @doc """
  Authenticates a user.
  """
  @spec authenticate(String.t(), String.t()) :: {:ok, User.t()} | :error
  def authenticate(username, password) do
    with user when not is_nil(user) <- Repo.get_by(User, username: username),
         {:ok, user} <- Bcrypt.check_pass(user, password) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  @doc """
  Returns if the `conn` is authenticated.
  """
  @spec authenticated?(Plug.Conn.t()) :: boolean()
  def authenticated?(conn), do: !!conn.assigns[:authenticated]

  @doc """
  Authenticates the `conn` from the session
  """
  @spec fetch_auth(Plug.Conn.t(), keyword()) :: Plug.Conn.t()
  def fetch_auth(conn, _opts \\ []) do
    with true <- get_session(conn, :authenticated),
         user when not is_nil(user) <- get_session(conn, :current_user) do
      conn
      |> assign(:authenticated, true)
      |> assign(:current_user, user)
    else
      _ -> assign(conn, :authenticated, false)
    end
  end
end
