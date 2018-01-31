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

defmodule KakteWeb.SessionController do
  @moduledoc """
  Controller for session management.
  """

  use KakteWeb, :controller

  import Expected.Plugs, only: [register_login: 1, logout: 1]

  alias KakteWeb.Auth

  @doc """
  Renders the login page.

  Redirects if there is already a session.
  """
  @spec login(Plug.Conn.t, map) :: Plug.Conn.t
  def login(conn, params) do
    page = params["redirect_to"] || "/"

    if Auth.authenticated?(conn),
      do: redirect(conn, to: page),
    else: render_login(conn, page)
  end

  @doc """
  Validates the credentials and creates a session.

  If the credentials are not valid, the login page is rendered again.
  """
  @spec create(Plug.Conn.t, map) :: Plug.Conn.t
  def create(conn, %{"username" => username,
                     "password" => password} = params) do
    page = params["redirect_to"] || "/"

    case Auth.authenticate(username, password) do
      {:ok, user} ->
        conn
        |> put_session(:authenticated, true)
        |> put_session(:current_user, user)
        |> register_login()
        |> redirect(to: page)

      :error ->
        conn
        |> put_flash(:error, gettext "Incorrect username or password.")
        |> render_login(page)
    end
  end

  @doc """
  Deletes the session.
  """
  @spec delete(Plug.Conn.t, map) :: Plug.Conn.t
  def delete(conn, _params) do
    conn
    |> logout()
    |> redirect(to: "/")
  end

  @spec render_login(Plug.Conn.t, String.t) :: Plug.Conn.t
  defp render_login(conn, redirect_to) do
    conn
    |> assign(:title, gettext "Log in")
    |> assign(:redirect_to, redirect_to)
    |> render("login.html")
  end
end
