ExUnit.configure(formatters: [ExUnit.CLIFormatter, ExUnitNotifier])
ExUnit.start()

# Setup test session and login stores
:ets.new(:session, [:named_table, :public])
Expected.MemoryStore.start_link()

Ecto.Adapters.SQL.Sandbox.mode(Kakte.Repo, :manual)
