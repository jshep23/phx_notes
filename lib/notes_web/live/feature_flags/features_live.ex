defmodule NotesWeb.FeatureFlags.FeaturesLive do
  alias Notes.Repository.Protocol.FeatureFlagRepo
  alias Notes.Parsers
  use NotesWeb, :live_view
  use Notes.PubSub

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

  def mount(%{"use_gen_server" => use_gen_server}, _, socket) do
    if connected?(socket) do
      subscribe(@feature_flag_changed_topic)
      subscribe(@new_dad_joke_topic)

      # Hack to use different repos. Will optionally use a future
      # Distributed repo when I get to it
      # Normally you would set this up in the application config
      repo = get_repo(use_gen_server)

      enabled_flags = repo |> FeatureFlagRepo.get_enabled()

      {:ok, socket |> assign(feature_flags: enabled_flags, repo: repo, dad_joke: "")}
    else
      {:ok, socket |> assign(feature_flags: [], dad_joke: "")}
    end
  end

  def handle_info(@feature_flag_changed_topic, %{assigns: %{repo: repo}} = socket) do
    {:noreply, socket |> assign(feature_flags: FeatureFlagRepo.get_enabled(repo))}
  end

  def handle_info({:new_dad_joke, joke}, socket) do
    {:noreply, assign(socket, dad_joke: joke)}
  end

  defp is_enabled(flags, name) do
    flag = flags |> Enum.find(&(&1.name == name))

    flag && flag.enabled
  end

  defp get_repo(use_gen_server) do
    if Parsers.parse_boolean(use_gen_server) do
      Notes.Repository.FeatureFlagGenServerRepo
    else
      raise "Only GenServer repo is supported at the moment"
    end
  end
end
