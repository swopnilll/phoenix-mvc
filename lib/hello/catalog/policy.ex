defmodule Hello.Catalog.Policy do
  @moduledoc """
  Authorization policy for the Catalog context.

  This is like a permissions checker. Each function answers:
  "Can this user perform this action?"

  Returns:
    - true  → allowed
    - false → denied
  """

  @behaviour Bodyguard.Policy

  alias Hello.Accounts.User

  # ============================================
  # :list_products - Who can view the products list?
  # ============================================

  # Rule 1: Admin can list products
  def authorize(:list_products, %User{role: "admin"}, _params), do: true

  # Rule 2: Manager can list products
  def authorize(:list_products, %User{role: "manager"}, _params), do: true

  # Rule 3: Anyone else? Denied.
  def authorize(:list_products, _user, _params), do: false

  # ============================================
  # :delete_product - Who can delete products?
  # ============================================

  # Only admin can delete
  def authorize(:delete_product, %User{role: "admin"}, _params), do: true

  # Everyone else? Denied.
  def authorize(:delete_product, _user, _params), do: false

  # ============================================
  # Catch-all: Deny anything not explicitly allowed
  # ============================================
  def authorize(_action, _user, _params), do: false
end
