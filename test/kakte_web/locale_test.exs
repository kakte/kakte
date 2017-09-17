defmodule KakteWeb.LocaleTest do
  use KakteWeb.ConnCase, async: true

  import KakteWeb.Locale

  @backend KakteWeb.Gettext

  test "set_locale/2 sets the locale from the query string if present and
        redirects to the page without the query string" do
    "en" = Gettext.get_locale(@backend)

    conn =
      :get
      |> build_conn("/test/?lang=eo")
      |> fetch_query_params
      |> fetch_cookies
      |> put_resp_cookie("locale", "fr")
      |> put_req_header("accept-language", "fr")
      |> set_locale

    assert Gettext.get_locale(@backend) == "eo"
    assert conn.cookies["locale"] == "eo"
    assert redirected_to(conn) == "/test/"
  end

  test "set_locale/2 sets the locale from the locale cookie if present" do
    "en" = Gettext.get_locale(@backend)

    build_conn()
    |> fetch_query_params
    |> fetch_cookies
    |> put_resp_cookie("locale", "eo")
    |> put_req_header("accept-language", "fr")
    |> set_locale

    assert Gettext.get_locale(@backend) == "eo"
  end

  test "set_locale/2 sets the locale from the Accept-Language HTTP header if
        present" do
    "en" = Gettext.get_locale(@backend)

    build_conn()
    |> fetch_query_params
    |> fetch_cookies
    |> put_req_header("accept-language", "fr")
    |> set_locale

    assert Gettext.get_locale(@backend) == "fr"
  end
end
