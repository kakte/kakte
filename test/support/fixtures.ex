defmodule Kakte.Fixtures do
  @moduledoc """
  A module for defining fixtures that can be used in tests.

  This module can be used with a list of fixtures to apply as parameter:

      use Kakte.Fixtures, [:user]
  """

  def user do
    alias Kakte.Accounts
    alias Kakte.Accounts.User

    quote do
      @password "U[.2)hkvL#6<"
      @valid_attrs %{
        username: "john",
        email: "john@kakte.io",
        password: @password,
        password_confirmation: @password,
        fullname: "John Smith",
      }

      @new_password "s0jH,Fst;HQm"
      @update_attrs %{
        username: "fred",
        email: "fred@kakte.io",
        password: @new_password,
        password_confirmation: @new_password,
        fullname: "Fred Smith",
      }

      @invalid_attrs %{
        username: nil,
        email: nil,
        password: nil,
        password_confirmation: nil,
        fullname: nil,
      }

      @user %User{
        id: 1,
        username: @valid_attrs.username,
        email: @valid_attrs.email,
        password_hash: Comeonin.Bcrypt.hashpwsalt(@password),
        fullname: @valid_attrs.fullname,
        inserted_at: DateTime.utc_now,
        updated_at: DateTime.utc_now,
      }

      def user_fixture(attrs \\ %{}) do
        {:ok, user} =
          attrs
          |> Enum.into(@valid_attrs)
          |> Accounts.register

        user
      end
    end
  end

  @doc """
  Apply the `fixtures`.
  """
  defmacro __using__(fixtures) when is_list(fixtures) do
    for fixture <- fixtures, is_atom(fixture),
      do: apply(__MODULE__, fixture, [])
  end
end