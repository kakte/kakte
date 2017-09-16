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

defmodule Kakte.Application do
  @moduledoc """
  Kakte OTP Application.
  """

  use Application

  alias KakteWeb.Endpoint

  @impl true
  def start(_type, _args) do
    children = [
      Kakte.Repo,         # Start the Ecto repository (for database)
      KakteWeb.Endpoint,  # Start the web endpoint
    ]

    opts = [strategy: :one_for_one, name: Kakte.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration whenever the application
  # is updated.
  @spec config_change(term, term, term) :: :ok
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
