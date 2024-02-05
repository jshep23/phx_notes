defmodule FeatureFlagsService.Flags do
  use GenServer
  use FeatureFlagsService.PubSub

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(:get_feature_flags, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:get_enabled_feature_flags, _from, state) do
    {:reply, Enum.filter(state, & &1.enabled), state}
  end

  def handle_cast({:add_feature_flag, flag}, state) do
    {:noreply, [flag | state] |> Enum.uniq_by(& &1.name)}
  end

  def handle_cast({:remove_feature_flag, name}, state) do
    {:noreply, Enum.reject(state, &(&1.name == name))}
  end

  def handle_cast({:toggle_feature_flag, name}, state) do
    new_state =
      Enum.map(state, fn flag ->
        if flag.name == name, do: %{flag | enabled: !flag.enabled}, else: flag
      end)

    {:noreply, new_state}
  end

  def get_feature_flags do
    GenServer.call(__MODULE__, :get_feature_flags)
  end

  def get_enabled_feature_flags do
    GenServer.call(__MODULE__, :get_enabled_feature_flags)
  end

  def add_feature_flag(flag) do
    GenServer.cast(__MODULE__, {:add_feature_flag, flag})
    publish(@feature_flag_changed_topic)
  end

  def remove_feature_flag(name) do
    GenServer.cast(__MODULE__, {:remove_feature_flag, name})
    publish(@feature_flag_changed_topic)
  end

  def toggle_feature_flag(name) when is_binary(name),
    do: toggle_feature_flag(String.to_atom(name))

  def toggle_feature_flag(name) do
    GenServer.cast(__MODULE__, {:toggle_feature_flag, name})
    publish(@feature_flag_changed_topic)
  end
end
