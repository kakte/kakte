defmodule KakteWeb.SessionControllerTest do
  use KakteWeb.ConnCase

  alias Expected.Login
  alias Expected.MemoryStore, as: LoginStore

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

    test "POST /login logs the user in if the credentials are correct",
         %{conn: conn} do
      user = user_fixture()

      # Ensure there is no previous login in the store
      Expected.delete_all_user_logins(user.username)

      conn = post conn, session_path(conn, :create),
                  username: user.username,
                  password: @password

      assert get_session(conn, :authenticated)
      assert conn.resp_cookies["_kakte_auth"]
      assert [%Login{}] = Expected.list_user_logins(user.username)
    end

    test "POST /login redirects to the correct page if the credentials are
          correct", %{conn: conn} do
      user = user_fixture()

      conn = post conn, session_path(conn, :create),
                  redirect_to: "/test",
                  username: user.username,
                  password: @password

      assert redirected_to(conn) == "/test"
    end

    test "POST /login renders /login with an error message if the credentials
          are incorrect", %{conn: conn} do
      conn = post conn, session_path(conn, :create),
                  username: "test",
                  password: "test"

      refute get_session(conn, :authenticated)
      assert html_response(conn, 200) =~ "Incorrect username or password."
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

    test "GET /logout logs the user out and redirects to the home page",
         %{conn: conn} do
      auth_cookie = conn.cookies["_kakte_auth"]
      [encoded_user, serial, _] = String.split(auth_cookie, ".")
      user = Base.decode64!(encoded_user)

      assert {:ok, _} = LoginStore.get(user, serial, :login_store)

      conn = get conn, session_path(conn, :delete)

      assert redirected_to(conn) == "/"
      assert {:error, :no_login} = LoginStore.get(user, serial, :login_store)
    end
  end
end
