defmodule NotesWeb.UserDetailsLive do
  alias Notes.Domain.User
  use NotesWeb, :live_view
  use NotesWeb.ValidatingForm
  use NotesWeb.PubSub
  import NotesWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <div>
      <div class="mx-auto font-bold text-2xl text-center pb-5">
        User Details
      </div>

      <.simple_form for={@form} phx-submit="save" phx-change="validate">
        <.input label="First Name" name="first_name" field={@form[:first_name]} />
        <.input label="Last Name" name="last_name" field={@form[:last_name]} />
        <.input label="Email" name="email" field={@form[:email]} />
        <:actions>
          <.button phx-click="save" type="submit">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    form = connected?(socket) |> new_form()
    {:ok, assign(socket, form: form, user: nil)}
  end

  def handle_event("validate", params, socket) do
    form =
      %User{}
      |> User.changeset(params)
      |> with_validation()
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", _params, %{assigns: %{form: form}} = socket) do
    if form.source.valid? do
      user = form.source |> User.from_changeset()
      publish(@user_created_topic, user)

      {:noreply, socket}
    else
      {:noreply, socket |> put_flash(:error, "Invalid form")}
    end
  end

  defp new_form(true) do
    %User{}
    |> User.changeset()
    |> with_validation()
    |> to_form()
  end

  defp new_form(false) do
    %User{}
    |> User.changeset()
    |> to_form()
  end
end
