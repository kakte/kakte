defmodule KakteWeb.PageControllerTest do
  use KakteWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Hello from kakte :-)"
  end
end
