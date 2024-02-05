defmodule Notes.JobScheduler do
  use GenServer
  alias Notes.Services.FeatureFlagService
  alias Notes.PubSub
  alias Notes.FeatureFlagsPubSub
  use Notes.PubSub.Topics.FeatureFlagTopics
  use Notes.PubSub.Topics.NotesTopics

  @dad_joke_interval 10_000

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_) do
    FeatureFlagsPubSub.subscribe(@feature_flag_changed_topic)
    schedule_jobs(:wait)
    {:ok, []}
  end

  def handle_info(:new_dad_joke, _) do
    PubSub.publish(@new_dad_joke_topic, {:new_dad_joke, Notes.Repository.DadJokeRepo.get_joke()})
    {:noreply, schedule_jobs()}
  end

  def handle_info(@feature_flag_changed_topic, _) do
    {:noreply, schedule_jobs()}
  end

  def handle_info(:schedule_jobs, _) do
    {:noreply, schedule_jobs()}
  end

  defp schedule_jobs(:wait, ms \\ 5000) do
    Process.send_after(self(), :schedule_jobs, ms)
  end

  defp schedule_jobs() do
    flags = FeatureFlagService.get_enabled()
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
