alias Commerce.Billing
alias Commerce.Billing.Response

defmodule Store.CheckoutController do
  use Store.Web, :controller

  def index(conn, _params) do
    render conn, "index.html",
      card: %Billing.CreditCard{},
      address: %Billing.Address{},
      error: nil
  end

  def create(conn, params) do
    IO.inspect(params)

    render conn, "thank-you.html"
  end
end
