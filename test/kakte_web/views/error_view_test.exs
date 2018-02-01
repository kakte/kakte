defmodule KakteWeb.ErrorViewTest do
  use KakteWeb.ConnCase, async: true

  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(KakteWeb.ErrorView, "404.html", []) ==
             "Page not found"
  end

  test "render 500.html" do
    assert render_to_string(KakteWeb.ErrorView, "500.html", []) ==
             "Internal server error"
  end

  test "renders any other error as a 500" do
    assert render_to_string(KakteWeb.ErrorView, "505.html", []) ==
             "Internal server error"
  end
end
