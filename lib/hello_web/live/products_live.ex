defmodule HelloWeb.ProductsLive do
  use HelloWeb, :live_view

  alias Hello.Catalog

  def mount(_params, _session, socket) do
    # direct DB call, no fetch/await needed
    products = Catalog.list_products()

    # socket = assign(socket, :products, products)
    # assign() puts data into the socket — like setState in React
    # :products is the key, products is the value

    socket =
      socket
      |> assign(:products, products)
      |> assign(:loading, false)
      |> assign(:page_title, "Products")

    {:ok, socket}
  end

  def handle_event("delete_product", %{"id" => id}, socket) do
    Catalog.delete_product(id)
    products = Catalog.list_products()
    {:noreply, assign(socket, :products, products)}
  end

  @spec render(any()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1>Products</h1>

    <ul>
      <%= for product <- @products do %>
        <li>
          <strong>{product.name}</strong>
          — ${product.price}
          <button phx-click="delete_product" phx-value-id={product.id}>
            Delete
          </button>
        </li>
      <% end %>
    </ul>
    """
  end
end
