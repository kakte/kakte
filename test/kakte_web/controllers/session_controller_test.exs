defmodule KakteWeb.SessionControllerTest do
  use KakteWeb.ConnCase

  describe "when the connection is not authenticated" do
    setup [:guest]

    test "GET /login renders the login form", %{conn: conn} do
      conn = get conn, session_path(conn, :login)
      assert html_response(conn, 200) =~ "Username"
      assert html_response(conn, 200) =~ "Password"
      assert html_response(conn, 200) =~ "Log in"
    end

    test "the login form contains a hidden redirect_to field", %{conn: conn} do
      conn = get conn, session_path(conn, :login, redirect_to: "/test")
      assert html_response(conn, 200) =~
        ~S(<input type="hidden" name="redirect_to" value="/test">)
    end
  end

  describe "when the connection is authenticated" do
    setup [:user]

    test "GET /login redirects to the home page if there is no redirect_to
          parameter", %{conn: conn} do
      conn = get conn, session_path(conn, :login)
      assert redirected_to(conn) == "/"
    end

    test "GET /login redirects to the page provided by the redirect_to
          parameter", %{conn: conn} do
      conn = get conn, session_path(conn, :login, redirect_to: "/test")
      assert redirected_to(conn) == "/test"
    end
  end
end
