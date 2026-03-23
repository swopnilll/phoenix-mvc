defmodule HelloWeb.ProductsLive do
  use HelloWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>Products</h1>
    """
  end

end
