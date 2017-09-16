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

defmodule KakteWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  use Phoenix.HTML

  @doc """
  Generates tag for inlined form input errors.
  """
  @spec error_tag(Phoenix.HTML.Form.t, atom) :: [Phoenix.HTML.safe]
  def error_tag(form, field) do
    Enum.map Keyword.get_values(form.errors, field), fn (error) ->
      content_tag :span, translate_error(error), class: "help-block"
    end
  end

  @doc """
  Translates an error message using gettext.
  """
  @spec translate_error({String.t, map}) :: String.t
  def translate_error({msg, opts}) do
    # Because error messages were defined within Ecto, we must call the Gettext
    # module passing our Gettext backend. We also use the "errors" domain as
    # translations are placed in the errors.po file. Ecto will pass the :count
    # keyword if the error message is meant to be pluralized. On your own code
    # and templates, depending on whether you need the message to be pluralized
    # or not, this could be written simply as:
    #
    #     dngettext "errors", "1 file", "%{count} files", count
    #     dgettext "errors", "is invalid"
    #
    if count = opts[:count] do
      Gettext.dngettext(KakteWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(KakteWeb.Gettext, "errors", msg, opts)
    end
  end
end
