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

defmodule KakteWeb.Router do
  @moduledoc """
  Kakte’s web router.
  """

  use KakteWeb, :router

  import KakteWeb.Auth, only: [fetch_auth: 2]
  import KakteWeb.Locale, only: [set_locale: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_auth
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :set_locale
  end

  scope "/", KakteWeb do
    pipe_through :browser

    # General pages
    get "/", PageController, :index

    # Session management
    get "/login", SessionController, :login
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete
  end
end
