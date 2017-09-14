# Contributing to kakte

This project uses [git-flow](https://github.com/petervanderdoes/gitflow-avh).
The `master` branch is reserved to releases: the development process occurs on
`develop` and feature branches. **Please never commit to master.**

## Setup

### Local repository

If the AVH edition of [git-flow](https://github.com/petervanderdoes/gitflow-avh)
is not installed yet on your machine, I advise you to do so. You could use git
bare metal, but using git-flow simplifies the process.

1. Fork the repository

2. Clone your fork to a local repository:

        $ git clone https://github.com/<your_name>/kakte.git
        $ cd kakte

3. Add the main repository as a remote:

        $ git remote add upstream https://kakte/kakte.git

4. Setup git-flow on the project (git-flow must be installed for the script to
    work):

        $ ./.gitsetup

5. Checkout to `develop`:

        $ git checkout develop

### Development environment

1. Install:

    * [asdf](https://github.com/asdf-vm/asdf)
    * Node.js & npm


2. Install Erlang and Elixir plugins for asdf:

        $ asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
        $ asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git

3. In the project repository, install the build toolchain:

        $ cd kakte
        $ asdf install

4. Fetch the project dependencies and build the project:

        $ mix do deps.get, compile

5. Install assets dependencies:

        $ cd assets && npm install

6. Setup the database:

        $ mix ecto.setup

7. Launch the application:

        $ iex -S mix phx.server

You can then visit http://localhost:4000.

## Workflow

When you want to work on a new *feature*\*, use the following workflow:

\* *Little changes are discussed below. You should ask before starting a new
feature to ensure your work will really be helpful ;-)*

1. Checkout to `develop` and apply the last upstream changes (use rebase, not
    merge!):

        $ git checkout develop
        $ git fetch --all --prune
        $ git rebase upstream/develop

2. Start a new feature:

        $ git flow feature start <feature_name>

3. Work on your feature (don’t forget to write some tests):

        # Some work
        $ git commit -am "My first change"
        # Some work
        $ git commit -am "My second change"
        ...

4. When your feature is ready, feel free to use
    [interactive rebase](https://help.github.com/articles/about-git-rebase/) so
    your history looks clean and is easy to follow. Then, apply the last
    upstream changes on `develop` to prepare integration:

        $ git checkout develop
        $ git fetch --all --prune
        $ git rebase upstream/develop

5. If there were commits on `develop` since the beginning of your feature
    branch, integrate them:

        $ git checkout <my_feature_branch>
        $ git merge develop

6. Run the tests and static analyzers to ensure there is no regression and all
    works as expected:

        $ mix test --stale
        $ mix dialyzer
        $ mix credo

7. If it’s all good, open a pull request to merge your feature branch into the
    `develop` branch on the main repository.

For small changes, please create a bare git branch. On `develop`:

    $ git checkout -b <branch_name>

Then, when you’re done, please *rebase* your branch on `develop` if there were
changes:

    $ git checkout develop
    $ git fetch --all --prune
    $ git rebase upstream/develop
    $ git checkout <branch_name>
    $ git rebase develop

Then, create a pull request.
