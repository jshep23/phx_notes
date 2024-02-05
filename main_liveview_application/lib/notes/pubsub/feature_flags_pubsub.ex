defmodule Notes.FeatureFlagsPubSub do
  def subscribe(topic) when is_binary(topic) do
    Phoenix.PubSub.subscribe(Application.get_env(:notes, :feature_flag_pub_sub), topic)
  end

  def subscribe(topics) when is_list(topics) do
    Enum.each(topics, &subscribe/1)
  end

  def publish(topic, message \\ nil)

  def publish(topic, message) do
    Phoenix.PubSub.broadcast(
      Application.get_env(:notes, :feature_flag_pub_sub),
      topic,
      if(message, do: message, else: topic)
    )
  end
end
