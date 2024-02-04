defmodule NotesWeb.Dialogs do
  use Phoenix.Component

  slot :title, required: true
  slot :body, required: true
  slot :actions

  attr :action_slot_param, :any, default: nil
  attr :actions_html, :any, default: nil

  def dialog(assigns) do
    ~H"""
    <div class="relative z-10" aria-labelledby="modal-title" role="dialog" aria-modal="true">
      <div class="fixed inset-0 bg-zinc-500 bg-opacity-75 transition-opacity"></div>
      <div class="fixed inset-0 z-10 w-screen overflow-y-auto">
        <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
          <div class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
            <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4 ">
              <div class="sm:flex sm:items-start">
                <div class="mt-3 text-center sm:ml-4 sm:mt-0 sm:text-left w-full">
                  <h3 class="text-base font-semibold leading-6 text-gray-900" id="modal-title">
                    <%= render_slot(@title) %>
                  </h3>
                  <div class="mt-4 px-5 w-full max-h-[800px] overflow-y-auto">
                    <%= render_slot(@body) %>
                  </div>
                </div>
              </div>
            </div>
            <%= if @actions do %>
              <div class="px-4 py-3 sm:flex justify-end sm:px-6">
                <%= render_slot(@actions, @action_slot_param) %>
              </div>
            <% end %>
            <%= if @actions_html do %>
              <div class="px-4 py-3 sm:flex justify-end sm:px-6 ">
                <%= @actions_html %>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
