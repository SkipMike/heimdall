defmodule Heimdall.UPC do
  # Get rid of index based number ambiguities
  defguard is_even_digit(index) when rem(index, 2) > 0
  defguard is_odd_digit(index) when rem(index, 2) == 0

   def calculate_check_digit(upc) when is_binary(upc) do
    upc
    |> String.to_integer()
    |> calculate_check_digit()
  end

  def calculate_check_digit(upc) when is_integer(upc) do
    upc
    |> IO.inspect
    |> Integer.digits()
    |> process_digits()
  end

  defp process_digits(upc_digits) do
    upc_digits
    |> Enum.with_index
    |> Enum.reduce({0, 0}, &process_digit/2)
    |> handle_sums()
    |> rem(10)
    |> handle_remainder()
  end

  defp process_digit({digit, index}, {odd_sum, _} = sums) when is_odd_digit(index) do
    put_elem(sums, 0, odd_sum + digit)
  end

  defp process_digit({digit, index}, {_, even_sum} = sums) when is_even_digit(index) do
    put_elem(sums, 1, even_sum + digit)
  end

  defp handle_sums({odd_sum, even_sum}) do
    (odd_sum * 3) + even_sum
  end

  defp handle_remainder(0), do: 0
  defp handle_remainder(num), do: 10 - num
end
