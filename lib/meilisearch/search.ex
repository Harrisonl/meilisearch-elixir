defmodule Meilisearch.Search do
  @moduledoc """
  Collection of functions used to search for documents matching given query.

  [MeiliSearch Documentation - Search](https://docs.meilisearch.com/references/search.html)
  """
  alias Meilisearch.HTTP

  @doc """
  Search for documents matching a specific query in the given index.

  Passing `nil` for the search_query will result in a placeholder query being performed.
  (https://docs.meilisearch.com/guides/advanced_guides/search_parameters.html#query-q)

  ## Options

    * `offset` 	Number of documents to skip.  Defaults to `0`
    * `limit` 	Maximum number of documents returned.  Defaults to `20`

  ## Examples

      iex> Meilisearch.Search.search("meilisearch_test", "where art thou")
      {:ok,
      %{
        "exhaustiveNbHits" => false,
        "hits" => [
          %{
            "id" => 2,
            "tagline" => "They have a plan but not a clue",
            "title" => "O' Brother Where Art Thou"
          }
        ],
        "limit" => 20,
        "nbHits" => 1,
        "offset" => 0,
        "processingTimeMs" => 17,
        "query" => "where art thou"
      }}

      iex> Meilisearch.Search.search("meilisearch_test", "nothing will match")
      {:ok,
      %{
        "exhaustiveNbHits" => false,
        "hits" => [],
        "limit" => 20,
        "nbHits" => 0,
        "offset" => 0,
        "processingTimeMs" => 27,
        "query" => "nothing will match"
      }}
  """
  @spec search(String.t(), String.t(), Keyword.t()) :: HTTP.response()
  def search(uid, search_query, opts \\ [])

  def search(uid, nil, opts) do
    do_search(uid, opts)
  end

  def search(uid, search_query, opts) do
    do_search(uid, [{:q, search_query} | opts])
  end

  defp do_search(uid, opts), do: HTTP.get_request("indexes/#{uid}/search", [], params: opts)
end
