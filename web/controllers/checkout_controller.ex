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
    card    = get_card(params)
    address = get_address(params)

    response = Billing.authorize(:default_gateway, 199.95, card,
                                 billing_address: address,
                                 description: "T-Shirt")

    respond(conn, response,
      card: card,
      address: address)
  end

  defp respond(conn, {:error, response}, assigns) do
    assigns = Keyword.put(assigns, :error, response.raw["error"]["message"])

    render conn, "index.html", assigns
  end

  defp respond(conn, {:ok, response}, _) do
    render conn, "thank-you.html", response: response
  end

  defp get_card(params) do
    %Billing.CreditCard{name:       params["name"],
                        number:     params["card"],
                        expiration: get_expiration(params["year"], params["month"]),
                        cvc:        params["cvc"]}
  end

  defp get_expiration(year, month) when byte_size(year) > 0 and byte_size(month) > 0,
    do: {String.to_integer(year), String.to_integer(month)}

  defp get_expiration(_, _),
    do: {0, 0}

  defp get_address(params) do
    %Billing.Address{street1:     params["street1"],
                     street2:     params["street2"],
                     city:        params["city"],
                     region:      params["region"],
                     country:     params["country"],
                     postal_code: params["postal_code"]}
  end
end
