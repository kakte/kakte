defmodule KakteWeb.AuthTest do
  use KakteWeb.ConnCase, async: true

  import Plug.Test, only: [init_test_session: 2]
  import KakteWeb.Auth

  describe "authenticated?/1" do
    test "returns true if the connection is authenticated", %{conn: conn} do
      assert conn |> user_conn |> authenticated?
    end

    test "returns false if the connection is not authenticated",
         %{conn: conn} do
      assert not (conn |> guest_conn |> authenticated?)
    end
  end

  describe "fetch_auth/2" do
    test "authenticates the connection if the session is authenticated",
         %{conn: conn} do
      conn =
        conn
        |> init_test_session(%{})
        |> fetch_session
        |> put_session(:authenticated, true)
        |> put_session(:current_user, @user)
        |> fetch_auth

      assert conn.assigns[:authenticated] == true
      assert conn.assigns[:current_user] == @user
    end

    test "marks the connection as not authenticated if the session is not
          authenticated", %{conn: conn} do
      conn =
        conn
        |> init_test_session(%{})
        |> fetch_auth

      assert conn.assigns[:authenticated] == false
      assert conn.assigns[:current_user] == nil
    end

    test "marks the connection as not authenticated if it does not contain a
          valid user", %{conn: conn} do
      conn =
        conn
        |> init_test_session(%{})
        |> put_session(:authenticated, true)
        |> fetch_auth

      assert conn.assigns[:authenticated] ==  false
    end
  end
end
