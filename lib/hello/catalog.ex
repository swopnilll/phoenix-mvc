defmodule Hello.Catalog do
  @moduledoc """
  The Catalog context - handles all product-related operations.
  """

  alias Hello.Repo
  alias Hello.Catalog.Product

  # This line connects Bodyguard to our Policy module
  # When someone calls Bodyguard.permit?(Catalog, :action, user),
  # it delegates to Catalog.Policy.authorize(:action, user, params)
  defdelegate authorize(action, user, params), to: Hello.Catalog.Policy

  # Fetch all products from database
  def list_products do
    Repo.all(Product)
  end

  # Fetch a single product by ID — returns nil if not found
  def get_product(id) do
    Repo.get(Product, id)
  end

  # Delete a product by ID
  def delete_product(id) do
    product = Repo.get(Product, id)
    Repo.delete(product)
  end

end
