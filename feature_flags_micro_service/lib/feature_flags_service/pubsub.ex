defmodule FeatureFlagsService.PubSub do
  defmacro __using__(_) do
    quote do
      alias FeatureFlagsService.PubSub
      @feature_flag_changed_topic "feature_flag:changed"

      def subscribe(topic) when is_binary(topic) do
        Phoenix.PubSub.subscribe(FeatureFlagsService.PubSub, topic)
      end

      def subscribe(topics) when is_list(topics) do
        Enum.each(topics, &subscribe/1)
      end

      def send_to_all_nodes(topic, message \\ nil) do
        Phoenix.PubSub.broadcast(
          System.PubSub,
          topic,
          if(message, do: message, else: topic)
        )
      end

      def publish(topic, message \\ nil) do
        Phoenix.PubSub.broadcast(
          FeatureFlagsService.PubSub,
          topic,
          if(message, do: message, else: topic)
        )
      end
    end
  end
end
