defmodule KakteWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      use Kakte.Fixtures, [:user]

      import KakteWeb.Router.Helpers
      import Expected.Plugs, only: [register_login: 1]

      # The default endpoint for testing
      @endpoint KakteWeb.Endpoint

      ## Setup functions

      defp guest(%{conn: conn}) do
        %{conn: guest_conn(conn)}
      end

      defp user(%{conn: conn}) do
        %{conn: user_conn(conn)}
      end

      ## Connection manipulation functions

      defp browser_conn(conn) do
        conn
        |> bypass_through(KakteWeb.Router, :browser)
        |> get("/")
      end

      defp guest_conn(conn) do
        browser_conn(conn)
      end

      defp user_conn(conn) do
        conn
        |> browser_conn
        |> put_session(:authenticated, true)
        |> put_session(:current_user, @user)
        |> register_login()
        |> send_resp(:ok, "")
        |> browser_conn
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Kakte.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Kakte.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
