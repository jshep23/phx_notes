defmodule NotesWeb.FeatureFlags.FeatureFlagsConfigLive do
  alias Notes.Services.FeatureFlagService
  use NotesWeb, :live_view
  use Notes.PubSub.Topics.FeatureFlagTopics
  alias Notes.FeatureFlagsPubSub
  import NotesWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <div>
      <div class="mx-auto font-bold text-2xl text-center pb-5">
        Feature Flags <span :if={@feature_flag_source == :remote}>(Distributed)</span>
      </div>
      <div class="flex justify-center items-center m-5 text-center">
        Click the button below to open a new tab. Then turn feature flags
        on and off and see the changes reflected in this tab in real-time.
      </div>

      <div
        :if={@feature_flag_source == :remote}
        class="flex justify-center items-center m-5 text-center"
      >
        The events
        are being broadcasted to all nodes in the cluster from the feature flag microservice.
      </div>

      <div class="flex justify-center">
        <.button phx-click="open_features_tab" phx-hook="OpenTab">Open Features Tab</.button>
      </div>

      <ul class="list-disc list-inside">
        <%= for flag <- @feature_flags do %>
          <.input
            type="checkbox"
            name={flag.name}
            value={flag.name}
            label={flag.name}
            phx-click="toggle_flag"
            phx-value-name={flag.name}
            checked={flag.enabled}
          />
        <% end %>
      </ul>
    </div>
    """
  end

  def mount(_, _, socket) do
    if connected?(socket) do
      FeatureFlagsPubSub.subscribe(@feature_flag_changed_topic)
      FeatureFlagService.seed()
    end

    {:ok,
     socket
     |> assign(
       feature_flags: [],
       feature_flag_source: Application.get_env(:notes, :feature_flag_source)
     )}
  end

  def handle_info(@feature_flag_changed_topic, socket) do
    {:noreply, socket |> assign(feature_flags: FeatureFlagService.get_all())}
  end

  def handle_event("open_features_tab", _, socket) do
    {:noreply,
     push_event(socket, "open_tab", %{
       url: "http://localhost:4000/feature_flags/features"
     })}
  end

  def handle_event("toggle_flag", %{"name" => name}, socket) do
    FeatureFlagService.toggle(name)

    {:noreply, socket}
  end
end
