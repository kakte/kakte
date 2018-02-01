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

defmodule KakteWeb.Locale do
  @moduledoc """
  Module for setting the locale.
  """

  import Phoenix.Controller, only: [redirect: 2]
  import Plug.Conn, only: [assign: 3, halt: 1, put_resp_cookie: 3]

  @backend KakteWeb.Gettext
  @supported Gettext.known_locales(@backend)

  @doc """
  Sets the locale for the connection.

  The locale is inferred from, by priority order:

  * the `lang` query string,
  * the `locale` cookie,
  * the `Accept-Language` HTTP header,
  * the current Gettext locale.

  It is then put in `conn.assigns.locale` and in the Gettext configuration.
  """
  @spec set_locale(Plug.Conn.t(), keyword()) :: Plug.Conn.t()
  def set_locale(conn, _opts \\ []) do
    conn
    |> fetch_locale
    |> change_locale
    |> put_locale
  end

  @spec fetch_locale(Plug.Conn.t()) :: Plug.Conn.t()
  defp fetch_locale(conn) do
    locale =
      case conn.query_params["lang"] || conn.cookies["locale"] ||
             PlugBest.best_language(conn, @supported) ||
             Gettext.get_locale(@backend) do
        {_, locale, _} -> locale
        locale -> locale
      end

    assign(conn, :locale, locale)
  end

  @spec change_locale(Plug.Conn.t()) :: Plug.Conn.t()
  defp change_locale(%{query_params: %{"lang" => locale}} = conn) do
    conn
    |> put_resp_cookie("locale", locale)
    |> redirect(to: conn.request_path)
    |> halt
  end

  defp change_locale(conn), do: conn

  @spec put_locale(Plug.Conn.t()) :: Plug.Conn.t()
  defp put_locale(%{assigns: %{locale: locale}} = conn) do
    Gettext.put_locale(@backend, locale)
    conn
  end
end
