defmodule NotesWeb.StickyNote do
  use Phoenix.Component

  attr :text, :string
  attr :title, :string
  attr :bg_color, :string, values: ~w(bg-yellow-300 bg-blue-300 bg-green-300)
  attr :text_color, :string, values: ~w(black white gray-700)

  def note(assigns) do
    ~H"""
    <div
      class={[
        @bg_color,
        "p-4 max-w-sm rounded shadow-lg"
      ]}
      id="note"
    >
      <div class="text-start font-bold text-lg pb-2">
        <%= @title %>
      </div>
      <p class={"text-base text-#{@text_color} font-sans"}>
        <%= @text %>
      </p>
    </div>
    """
  end

  attr :text, :string
  attr :title, :string, default: ""

  def yellow_note(assigns) do
    ~H"""
    <.note bg_color="bg-yellow-300" text_color="gray-700" text={@text} title={@title} />
    """
  end

  attr :text, :string
  attr :title, :string, default: ""

  def blue_note(assigns) do
    ~H"""
    <.note bg_color="bg-blue-300" text_color="gray-700" text={@text} title={@title} />
    """
  end

  attr :text, :string
  attr :title, :string, default: ""

  def green_note(assigns) do
    ~H"""
    <.note bg_color="bg-green-300" text_color="gray-700" text={@text} title={@title} />
    """
  end
end
