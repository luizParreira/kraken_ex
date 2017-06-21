defmodule KrakenEx.PairRequiredParamError do
  defexception message: """
    To call this service, you need to add the `pair:` keyword as a parameter in order for your request to work.
  """
end
