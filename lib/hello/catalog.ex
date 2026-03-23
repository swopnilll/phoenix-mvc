defmodule Hello.Catalog do

  alias Hello.Repo
  alias Hello.Catalog.Product

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
