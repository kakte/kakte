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

  alias KakteWeb.Auth

  @doc """
  Renders the login page.

  Redirects if there is already a session.
  """
  @spec login(Plug.Conn.t, map) :: Plug.Conn.t
  def login(conn, params) do
    page = params["redirect_to"] || "/"

    if Auth.authenticated?(conn) do
      redirect conn, to: page
    else
      conn
      |> assign(:title, gettext "Log in")
      |> assign(:redirect_to, page)
      |> render("login.html")
    end
  end
end
