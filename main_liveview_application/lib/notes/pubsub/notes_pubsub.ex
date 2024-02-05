defmodule Notes.PubSub do
  def subscribe(topic) when is_binary(topic) do
    Phoenix.PubSub.subscribe(Notes.PubSub, topic)
  end

  def subscribe(topics) when is_list(topics) do
    Enum.each(topics, &subscribe/1)
  end

  def publish(topic, message \\ nil)

  def publish(topic, message) do
    Phoenix.PubSub.broadcast(
      Notes.PubSub,
      topic,
      if(message, do: message, else: topic)
    )
  end
end
