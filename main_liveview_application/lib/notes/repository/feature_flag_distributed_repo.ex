defmodule Notes.Repository.FeatureFlagDistributedRepo do
  alias Notes.Repository.Protocol.FeatureFlagRepo

  defstruct []

  def new() do
    %__MODULE__{}
  end

  defimpl FeatureFlagRepo, for: __MODULE__ do
    alias Notes.FeatureFlagsPubSub
    use Notes.PubSub.Topics.FeatureFlagTopics

    def seed(repo) do
      flags = [
        %{name: :basketball_tutorials, enabled: false},
        %{name: :dad_jokes, enabled: false}
      ]

      Enum.each(flags, &add(repo, &1))
    end

    def get_all(_) do
      # Call also request the flags from the flags microservice directly
      # Obviously more coupled, however this is useful for when you know there
      # is only one node running a particular service. This is common for
      # microservices that provide things like flags or other configuration
      GenServer.call({:global, :flags}, :get_feature_flags)
    end

    def get_enabled(_) do
      GenServer.call({:global, :flags}, :get_enabled_feature_flags)
    end

    def add(_, flag) do
      # Can use pub/sub to broadcast a message, which in this case is subscribed to
      # by the flags server. Decoupled way of communicating between nodes.
      FeatureFlagsPubSub.publish(@add_feature_flag_topic, {@add_feature_flag_topic, flag})
    end

    def remove(_, name) do
      FeatureFlagsPubSub.publish(
        @request_remove_feature_flag_topic,
        {@request_remove_feature_flag_topic, name}
      )
    end

    def toggle(_, name) do
      FeatureFlagsPubSub.publish(
        @request_toggle_feature_flag_topic,
        {@request_toggle_feature_flag_topic, name}
      )
    end
  end
end
