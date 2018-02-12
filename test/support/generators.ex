defmodule Kakte.Generators do
  @moduledoc """
  TODO: Doc
  A module for defining generators that can be used in tests.

  This module can be used with a list of generator collections to apply as
  parameter:

      use Kakte.Fixtures, [:user]
  """

  def user do
    alias Kakte.Accounts.User

    quote do
      use ExUnitProperties

      defp username, do: string(:ascii, min_length: 3)
      defp password, do: string(:ascii, min_length: 8)
      defp fullname, do: string(:printable)

      defp email do
        gen all user <- string(:printable, min_length: 1),
                domain <- string(:ascii, min_length: 1) do
          user <> "@" <> domain
        end
      end

      defp user_attrs do
        gen all username <- username(),
                email <- email(),
                password <- password(),
                fullname <- fullname() do
          %{
            username: username,
            email: email,
            password: password,
            password_confirmation: password,
            fullname: fullname
          }
        end
      end

      defp user do
        gen all attrs <- user_attrs(),
                id <- positive_integer(),
                inserted_at <- positive_integer(),
                updated_at <- positive_integer(),
                inserted_at <= updated_at do
          %User{
            id: id,
            username: attrs.username,
            email: attrs.email,
            password_hash: Comeonin.Bcrypt.hashpwsalt(attrs.password),
            fullname: attrs.fullname,
            inserted_at: inserted_at,
            updated_at: updated_at
          }
        end
      end
    end
  end

  @doc """
  Apply the generator `collections`.
  """
  defmacro __using__(collections) when is_list(collections) do
    for collection <- collections,
        is_atom(collection),
        do: apply(__MODULE__, collection, [])
  end
end
