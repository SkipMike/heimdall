defmodule HeimdallWeb.ApiController do
  use HeimdallWeb, :controller
  import Plug.Conn
  alias Heimdall.UPC


  # this route takes one upc, and returns the upc with the check digit added
  # http://0.0.0.0:4000/api/add_check_digit/1234
  def add_check_digit(conn, %{"upc" => upc}) do
    check_digit = UPC.calculate_check_digit(upc) |> Integer.to_string()
    upc_with_check_digit = "#{upc}#{check_digit}"
    _send_json(conn, 200, upc_with_check_digit)
  end

  # this route takes a comma separated list and should add a check digit to each element
  # http://0.0.0.0:4000/api/add_a_bunch_of_check_digits/12345,233454,34341432
  def add_a_bunch_of_check_digits(conn, %{"upcs" => upcs}) do
    check_digits_with_upc = String.split(upcs, ",")
    |> Enum.map(fn upc ->
      check_digit = UPC.calculate_check_digit(upc)
      "#{upc}#{check_digit}"
    end)

    _send_json(conn, 200, check_digits_with_upc)
  end

  # this is a thing to format your responses and return json to the client
  defp _send_json(conn, status, body) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(status, Poison.encode!(body))
  end

end
