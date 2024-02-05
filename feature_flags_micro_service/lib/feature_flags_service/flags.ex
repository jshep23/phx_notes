defmodule FeatureFlagsService.Flags do
  use GenServer
  use FeatureFlagsService.PubSub

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: {:global, :flags})
  end

  def init(state) do
    subscribe(@add_feature_flag_topic, :remote)
    subscribe(@request_remove_feature_flag_topic, :remote)
    subscribe(@request_toggle_feature_flag_topic, :remote)

    {:ok, state}
  end

  def handle_info({@add_feature_flag_topic, flag}, state) do
    add_feature_flag(flag)
    {:noreply, state}
  end

  def handle_info({@request_toggle_feature_flag_topic, name}, state) do
    toggle_feature_flag(name)
    {:noreply, state}
  end

  def handle_info({@request_remove_feature_flag_topic, name}, state) do
    remove_feature_flag(name)
    {:noreply, state}
  end

  def handle_call(:get_feature_flags, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:get_enabled_feature_flags, _from, state) do
    {:reply, Enum.filter(state, & &1.enabled), state}
  end

  def handle_cast({:add_feature_flag, flag}, state) do
    publish(@feature_flag_changed_topic)
    {:noreply, [flag | state] |> Enum.uniq_by(& &1.name)}
  end

  def handle_cast({:remove_feature_flag, name}, state) do
    publish(@feature_flag_changed_topic)
    {:noreply, Enum.reject(state, &(&1.name == name))}
  end

  def handle_cast({:toggle_feature_flag, name}, state) do
    new_state =
      Enum.map(state, fn flag ->
        if flag.name == name, do: %{flag | enabled: !flag.enabled}, else: flag
      end)

    publish(@feature_flag_changed_topic)
    {:noreply, new_state}
  end

  def get_feature_flags do
    GenServer.call({:global, :flags}, :get_feature_flags)
  end

  def get_enabled_feature_flags do
    GenServer.call({:global, :flags}, :get_enabled_feature_flags)
  end

  def add_feature_flag(flag) do
    GenServer.cast({:global, :flags}, {:add_feature_flag, flag})
  end

  def remove_feature_flag(name) do
    GenServer.cast({:global, :flags}, {:remove_feature_flag, name})
  end

  def toggle_feature_flag(name) when is_binary(name),
    do: toggle_feature_flag(String.to_atom(name))

  def toggle_feature_flag(name) do
    GenServer.cast({:global, :flags}, {:toggle_feature_flag, name})
  end
end
