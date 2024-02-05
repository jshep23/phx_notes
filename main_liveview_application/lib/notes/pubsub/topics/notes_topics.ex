defmodule Notes.PubSub.Topics.NotesTopics do
  defmacro __using__(_) do
    quote do
      @user_created_topic "user:created"
      @change_user_topic "user:change"
      @new_dad_joke_topic "new_dad_joke"
    end
  end
end
