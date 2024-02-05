defmodule Notes.NodeMonitor do
  use GenServer

  def start_link(target_node) do
    GenServer.start_link(__MODULE__, Enum.at(target_node, 0), name: __MODULE__)
  end

  def init(target_node) do
    schedule_check()
    {:ok, target_node}
  end

  def handle_info(:check_connection, target_node) do
    unless Node.ping(target_node) == :pong do
      Node.connect(target_node)
    end

    schedule_check()
    {:noreply, target_node}
  end

  defp schedule_check() do
    Process.send_after(self(), :check_connection, 10_000)
  end
end
