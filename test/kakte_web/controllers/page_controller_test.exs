defmodule KakteWeb.PageControllerTest do
  use KakteWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Hello from kakte :-)"
  end

  test "the locale is automatically set", %{conn: conn} do
    conn =
      conn
      |> put_resp_cookie("locale", "eo")
      |> get("/")

    assert html_response(conn, 200) =~ "Saluton el kakte-o :-)"
  end
end
