# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Hello.Repo.insert!(%Hello.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Hello.Repo
alias Hello.Catalog.Product

products = [
  %{name: "Laptop", price: Decimal.new("999.99"), description: "15-inch display, 16GB RAM"},
  %{name: "Headphones", price: Decimal.new("149.99"), description: "Wireless noise-canceling"},
  %{name: "Keyboard", price: Decimal.new("79.99"), description: "Mechanical RGB keyboard"},
  %{name: "Mouse", price: Decimal.new("49.99"), description: "Ergonomic wireless mouse"},
  %{name: "Monitor", price: Decimal.new("299.99"), description: "27-inch 4K display"}
]

for product <- products do
  Repo.insert!(%Product{
    name: product.name,
    price: product.price,
    description: product.description
  })
end

IO.puts("Seeded #{length(products)} products")
