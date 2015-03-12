defmodule Vex.Validators.Each do
  @moduledoc """
  Run the validation options across each item in the enumerable.

  ## Examples

      iex> Vex.Validators.Each.validate([1, 2], &is_integer/1)
      :ok

      iex> Vex.Validators.Each.validate(
      ...>   %{a: 1, b: 2}, fn ({k, v}) -> is_atom(k) and is_integer(v) end)
      :ok

      iex> Vex.Validators.Each.validate([1, :b], &is_integer/1)
      {:error, ["must be valid"]}
  """
  use Vex.Validator

  def validate(list, options) do
    unless_skipping(list, options) do
      case list
           |> Enum.map(&Vex.result(&1, options))
           |> List.flatten()
           |> Enum.filter(fn ({:ok, _, _}) -> false; (_) -> true end) do
        [] ->
          :ok
        errors when is_list(errors) ->
          {:error, (for {:error, _, _, message} <- errors, do: message)}
      end
    end
  end
end
