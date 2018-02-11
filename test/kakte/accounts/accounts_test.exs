defmodule Kakte.AccountsTest do
  use Kakte.DataCase

  alias Comeonin.Bcrypt
  alias Ecto.Changeset
  alias Kakte.Accounts

  describe "[users]" do
    use Kakte.Fixtures, [:user]

    alias Kakte.Accounts.User

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "get_user!/1 returns the user with given username" do
      user = user_fixture()
      assert Accounts.get_user!(user.username) == user
    end

    test "register_user/1 with valid data registers a user" do
      assert {:ok, %User{} = user} = Accounts.register(@valid_attrs)
      assert user.username == @valid_attrs.username
      assert user.email == @valid_attrs.email
      assert user.password == nil
      assert Bcrypt.checkpw(@password, user.password_hash)
      assert user.fullname == @valid_attrs.fullname
    end

    test "register_user/1 with invalid data returns an error changeset" do
      assert {:error, %Changeset{}} = Accounts.register(@invalid_attrs)
    end

    test "the username is mandatory for registration" do
      assert {:error, %Changeset{} = changeset} =
               @valid_attrs
               |> Map.delete(:username)
               |> Accounts.register()

      assert %{username: ["can't be blank"]} = errors_on(changeset)
    end

    test "an email is mandatory for registration" do
      assert {:error, %Changeset{} = changeset} =
               @valid_attrs
               |> Map.delete(:email)
               |> Accounts.register()

      assert %{email: ["can't be blank"]} = errors_on(changeset)
    end

    test "a password is mandatory for registration" do
      assert {:error, %Changeset{} = changeset} =
               @valid_attrs
               |> Map.delete(:password)
               |> Accounts.register()

      assert %{password: ["can't be blank"]} = errors_on(changeset)
    end

    test "the password must match confirmation for registration" do
      assert {:error, %Changeset{} = changeset} =
               @valid_attrs
               |> Map.put(:password_confirmation, "not password")
               |> Accounts.register()

      assert %{password_confirmation: ["does not match confirmation"]} =
               errors_on(changeset)
    end

    test "the password must be at least 8 characters" do
      assert {:error, %Changeset{} = changeset} =
               @valid_attrs
               |> Map.put(:password, "toto")
               |> Accounts.register()

      assert %{
               password: ["The password should be at least 8 characters long."]
             } = errors_on(changeset)
    end

    test "the password must not be too easy" do
      assert {:error, %Changeset{} = changeset} =
               @valid_attrs
               |> Map.put(:password, "password")
               |> Accounts.register()

      assert %{
               password: [
                 "The password you have chosen is weak because it is easy to" <>
                   " guess. Please choose another one."
               ]
             } = errors_on(changeset)
    end

    test "the full name is optional for registration" do
      assert {:ok, %User{}} =
               @valid_attrs
               |> Map.delete(:fullname)
               |> Accounts.register()
    end

    test "a username can be registered only once" do
      user_fixture()

      assert {:error, %Changeset{} = changeset} =
               @update_attrs
               |> Map.put(:username, @valid_attrs.username)
               |> Accounts.register()

      assert %{username: ["has already been taken"]} = errors_on(changeset)
    end

    test "an email can be used only for one user" do
      user_fixture()

      assert {:error, %Changeset{} = changeset} =
               @update_attrs
               |> Map.put(:email, @valid_attrs.email)
               |> Accounts.register()

      assert %{email: ["has already been taken"]} = errors_on(changeset)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.username == @update_attrs.username
      assert user.email == @update_attrs.email
      assert user.password == nil
      assert Bcrypt.checkpw(@new_password, user.password_hash)
      assert user.fullname == @update_attrs.fullname
    end

    test "update_user/2 with invalid data returns an error changeset" do
      user = user_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_user(user, @invalid_attrs)

      assert Accounts.get_user!(user.id) == user
    end

    test "there is no mandatory field for update" do
      user = user_fixture()
      assert {:ok, ^user} = Accounts.update_user(user, %{})
      assert Accounts.get_user!(user.id) == user
    end

    test "the username cannot be set to nil when updating a user" do
      user = user_fixture()

      assert {:error, %Changeset{} = changeset} =
               Accounts.update_user(user, %{username: nil})

      assert %{username: ["can't be blank"]} = errors_on(changeset)
    end

    test "the email cannot be set to nil when updating a user" do
      user = user_fixture()

      assert {:error, %Changeset{} = changeset} =
               Accounts.update_user(user, %{email: nil})

      assert %{email: ["can't be blank"]} = errors_on(changeset)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Changeset{} = Accounts.change_user(user)
    end

    test "change_user_registration/1 returns a user changeset" do
      user = user_fixture()
      assert %Changeset{} = Accounts.change_user_registration(user)
    end
  end
end
