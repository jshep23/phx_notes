defmodule Notes.JobScheduler do
  use GenServer
  alias Notes.FeatureFlagServer
  use Notes.PubSub

  @dad_joke_interval 10_000

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_) do
    subscribe(@feature_flag_changed_topic)
    {:ok, schedule_jobs()}
  end

  def handle_info(:new_dad_joke, _) do
    publish(@new_dad_joke_topic, {:new_dad_joke, Notes.Repository.DadJokeRepo.get_joke()})
    {:noreply, schedule_jobs()}
  end

  def handle_info(@feature_flag_changed_topic, _) do
    {:noreply, schedule_jobs()}
  end

  defp schedule_jobs() do
    flags = FeatureFlagServer.get_enabled_feature_flags()
    scheduled_jobs = %{}

    scheduled_jobs =
      maybe_schedule_dad_jokes(scheduled_jobs, flags)

    {:ok, scheduled_jobs}
  end

  defp maybe_schedule_dad_jokes(jobs, flags) do
    if Enum.any?(flags, &(&1.name == :dad_jokes)) do
      Map.put(jobs, :dad_jokes, Process.send_after(self(), :new_dad_joke, @dad_joke_interval))
    else
      jobs
    end
  end
end
