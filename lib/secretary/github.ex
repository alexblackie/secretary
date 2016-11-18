defmodule Secretary.Github do
  @moduledoc """
  An interface to the Github API, extracted away into its own module for
  testing ease.
  """

  @doc """
  Given a list of binaries representing label names, add each to a given PR.
  """
  @spec label_issue(List.t, String.t, String.t) :: {:ok, String.t} | {:error, String.t}
  def label_issue(labels, repo, pull_number) do
    {:ok, json_labels} = Poison.encode(labels)
    resp = :hackney.post(
      api_url("/repos/#{repo}/issues/#{pull_number}/labels"),
      [{"Authorization", "token #{github_token}"}],
      json_labels,
      []
    )

    case resp do
      {:ok, 200, _, client} -> :hackney.body(client)
      {_, _, _, client} ->
        {:ok, body} = :hackney.body(client)
        {:error, body}
    end
  end

  # --- private ---

  defp api_url(path) do
    "#{Application.get_env(:secretary, :github_api)}#{path}"
  end

  defp github_token do
    Application.get_env(:secretary, :github_token)
  end
end
