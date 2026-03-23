defmodule HelloWeb.HomeLive do
  use HelloWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>Home</h1>
    <.link navigate={~p"/products"}>
      <button>Go To Products</button>
    </.link>
    """
  end

end
