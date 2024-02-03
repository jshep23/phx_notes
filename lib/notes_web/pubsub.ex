defmodule NotesWeb.PubSub do
  defmacro __using__(_) do
    quote do
      alias NotesWeb.PubSub
      @user_created_topic "user:created"
      @change_user_topic "user:change"

      def subscribe(topic) when is_binary(topic) do
        Phoenix.PubSub.subscribe(Notes.PubSub, topic)
      end

      def subscribe(topics) when is_list(topics) do
        Enum.each(topics, &subscribe/1)
      end

      def publish(topic, message \\ nil) do
        Phoenix.PubSub.broadcast(
          Notes.PubSub,
          topic,
          if(message, do: message, else: topic)
        )
      end
    end
  end
end
