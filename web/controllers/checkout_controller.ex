defmodule Store.CheckoutController do
  use Store.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
