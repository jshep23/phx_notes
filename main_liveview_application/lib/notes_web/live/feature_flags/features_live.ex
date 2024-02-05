defmodule NotesWeb.FeatureFlags.FeaturesLive do
  require Logger
  alias Notes.Services.FeatureFlagService
  use NotesWeb, :live_view
  use Notes.PubSub.Topics.FeatureFlagTopics
  use Notes.PubSub.Topics.NotesTopics
  alias Notes.FeatureFlagsPubSub
  alias Notes.PubSub

  def render(assigns) do
    ~H"""
    <div>
      <div :if={is_enabled(@feature_flags, :basketball_tutorials)} class="mx-auto">
        This is how you basketball
        <img src="/images/how_to_basketball.gif" alt="Basketball Tutorial" />
      </div>

      <div :if={is_enabled(@feature_flags, :dad_jokes)}>
        <div class="mx-auto font-bold text-2xl text-center pb-5">
          Dad Jokes! New joke every 10 seconds
        </div>
        <div class="flex justify-center items-center m-5">
          <%= @dad_joke %>
        </div>
      </div>
    </div>
    """
  end

  def mount(_, _, socket) do
    if connected?(socket) do
      FeatureFlagsPubSub.subscribe(@feature_flag_changed_topic)
      PubSub.subscribe(@new_dad_joke_topic)

      {:ok, socket |> assign(feature_flags: FeatureFlagService.get_enabled(), dad_joke: "")}
    else
      {:ok, socket |> assign(feature_flags: [], dad_joke: "")}
    end
  end

  def handle_info(@feature_flag_changed_topic, socket) do
    {:noreply, socket |> assign(feature_flags: FeatureFlagService.get_enabled())}
  end

  def handle_info({:new_dad_joke, joke}, socket) do
    {:noreply, assign(socket, dad_joke: joke)}
  end

  defp is_enabled(flags, name) do
    flag = flags |> Enum.find(&(&1.name == name))

    flag && flag.enabled
  end
end
