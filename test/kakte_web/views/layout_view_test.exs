defmodule KakteWeb.LayoutViewTest do
  use KakteWeb.ConnCase, async: true

  import Phoenix.View, only: [render_to_string: 3]
  import KakteWeb.LayoutView

  @view KakteWeb.LayoutView
  @test_view KakteWeb.PageView
  @test_template "index.html"

  describe "title/1 sets the title" do
    test "to “Kakte” if no title is provided" do
      assert title(nil) == "Kakte"
    end

    test "to “Kakte — <title>” if a title is provided" do
      assert title("Test") == "Kakte — Test"
    end
  end

  describe "in the app layout" do
    setup [:guest]

    test "the title is set according to its assign", %{conn: conn} do
      assert render_layout("app.html", conn: conn, title: "Test") =~
        "<title>#{title("Test")}</title>"
    end
  end

  describe "when the connection is not authenticated" do
    setup [:guest]

    test "a link to log in is rendered", %{conn: conn} do
      assert render_layout("app.html", conn: conn) =~ "Log in"
    end

    test "the user’s username is not rendered", %{conn: conn} do
      assert not (render_layout("app.html", conn: conn) =~ @user.username)
    end

    test "the user menu is not rendered", %{conn: conn} do
      assert not (render_layout("app.html", conn: conn) =~ "user-menu")
    end
  end

  describe "when the connection is authenticated as a user" do
    setup [:user]

    test "no link to log in is rendered", %{conn: conn} do
      assert not (render_layout("app.html", conn: conn) =~ "Log in")
    end

    test "the user’s username is rendered", %{conn: conn} do
      assert render_layout("app.html", conn: conn) =~ @user.username
    end

    test "the user menu is rendered", %{conn: conn} do
      assert render_layout("app.html", conn: conn) =~ "user-menu"
    end
  end

  defp render_layout(layout, assigns) do
    assigns = [layout: {@view, layout}] ++ assigns
    render_to_string(@test_view, @test_template, assigns)
  end
end
