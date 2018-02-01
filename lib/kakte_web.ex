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

defmodule KakteWeb do
  @moduledoc """
  Entrypoint module for defining kakte’s web interface.

  This can be used as:

      use KakteWeb, :controller
      use KakteWeb, :view
      use KakteWeb, :router
      use KakteWeb, :channel
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: KakteWeb
      import Plug.Conn
      import KakteWeb.Router.Helpers
      import KakteWeb.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/kakte_web/templates",
        namespace: KakteWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import KakteWeb.Router.Helpers
      import KakteWeb.ErrorHelpers
      import KakteWeb.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import KakteWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
