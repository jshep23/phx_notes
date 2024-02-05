defmodule Notes.PubSub.Topics.FeatureFlagTopics do
  defmacro __using__(_) do
    quote do
      @add_feature_flag_topic "feature_flag:add"
      @feature_flag_changed_topic "feature_flag:changed"
      @request_remove_feature_flag_topic "feature_flag:remove"
      @request_toggle_feature_flag_topic "feature_flag:toggle"
    end
  end
end
