defmodule HelloWeb.HomeLive do
  use HelloWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>Home</h1>
    <.link navigate={~p"/products"}>
      <button>Go To Products</button>
    </.link>
    <br>
    <.link navigate={~p"/products-upload"}>
      <button>Upload Product Data</button>
    </.link>
    """
  end
end
