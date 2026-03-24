defmodule HelloWeb.ProductsLive do
  use HelloWeb, :live_view

  alias Hello.Catalog
  alias Hello.Accounts

  def mount(_params, _session, socket) do
    # For now, we'll get user from URL param (later this comes from auth session)
    # Default to user ID 1 if not specified
    current_user = Accounts.get_user(1)

    # Check if user can view products
    if current_user && Bodyguard.permit?(Catalog, :list_products, current_user) do
      products = Catalog.list_products()

      socket =
        socket
        |> assign(:products, products)
        |> assign(:current_user, current_user)
        |> assign(:can_delete, Bodyguard.permit?(Catalog, :delete_product, current_user))
        |> assign(:page_title, "Products")

      {:ok, socket}
    else
      # Not authorized - redirect to home
      socket =
        socket
        |> put_flash(:error, "You don't have permission to view products")
        |> redirect(to: "/")

      {:ok, socket}
    end
  end

  def handle_event("delete_product", %{"id" => id}, socket) do
    current_user = socket.assigns.current_user

    # Check permission before deleting
    if Bodyguard.permit?(Catalog, :delete_product, current_user) do
      Catalog.delete_product(id)
      products = Catalog.list_products()
      {:noreply, assign(socket, :products, products)}
    else
      {:noreply, put_flash(socket, :error, "You don't have permission to delete products")}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="p-4">
      <h1 class="text-2xl font-bold mb-4">Products</h1>

      <p class="mb-4 text-sm text-gray-600">
        Logged in as: <strong>{@current_user.name}</strong> (role: {@current_user.role})
      </p>

      <ul class="space-y-2">
        <%= for product <- @products do %>
          <li class="flex items-center gap-4 p-2 bg-base-200 rounded">
            <strong>{product.name}</strong>
            <span>— ${product.price}</span>

            <%= if @can_delete do %>
              <button
                phx-click="delete_product"
                phx-value-id={product.id}
                class="btn btn-error btn-sm"
              >
                Delete
              </button>
            <% end %>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end
end
