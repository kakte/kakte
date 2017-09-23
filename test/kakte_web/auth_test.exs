defmodule KakteWeb.AuthTest do
  use KakteWeb.ConnCase, async: true

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
end
