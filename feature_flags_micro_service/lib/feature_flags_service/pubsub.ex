defmodule FeatureFlagsService.PubSub do
  defmacro __using__(_) do
    quote do
      alias FeatureFlagsService.PubSub
      @feature_flag_changed_topic "feature_flag:changed"
      @add_feature_flag_topic "feature_flag:add"
      @request_remove_feature_flag_topic "feature_flag:remove"
      @request_toggle_feature_flag_topic "feature_flag:toggle"

      def subscribe(topic) when is_binary(topic) do
        Phoenix.PubSub.subscribe(FeatureFlagsService.PubSub, topic)
      end

      def subscribe(topic, :remote) when is_binary(topic) do
        Phoenix.PubSub.subscribe(Remote.PubSub, topic)
      end

      def subscribe(topics) when is_list(topics) do
        Enum.each(topics, &subscribe/1)
      end

      def subscribe(topics, :remote) when is_list(topics) do
        Enum.each(topics, &subscribe(&1, :remote))
      end

      def publish(topic, message \\ nil) do
        Phoenix.PubSub.broadcast(
          Remote.PubSub,
          topic,
          if(message, do: message, else: topic)
        )
      end
    end
  end
end
