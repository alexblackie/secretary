defmodule Secretary.Ingestor do
  @moduledoc """
  This module is a GenServer that handles the processing of PR webhooks. Casts
  with raw github webhook payloads come in, and here is where we do all the
  processing and parsing necessary to eventually end up adding the labels we
  need via the API.
  """

  use GenServer

  @doc """
  Public API function for asynchronously queuing a webhook payload to be
  processed. Shorthand for a GenServer cast to this globally-named server.
  """
  def feed(payload) do
    GenServer.cast({:global, __MODULE__}, {:feed, payload})
  end

  # --- gen_server api ---

  @doc """
  Start a globally-named GenServer process of this module.
  """
  def start_link do
    {:ok, _} = GenServer.start_link(__MODULE__, [], name: {:global, __MODULE__})
  end

  @doc """
  GenServer callback for handling casts of webhook payload strings. It is
  recommended to rely on the simpler `feed/1` function, as opposed to casting
  directly to this module.
  """
  def handle_cast({:feed, raw_payload}, state) do
    # Decode the raw payload
    {:ok, payload} = Poison.decode(raw_payload)

    # Some variables to clean things up
    pull_ref = payload["pull_request"]["head"]["ref"]
    repo = payload["pull_request"]["repo"]["full_name"]
    pull_number = payload["pull_request"]["number"]

    # Generate list of labels we should add
    list_of_labels = Secretary.BranchParser.labels(pull_ref)

    # Make an API request to Github
    {:ok, 200, _, _} = :hackney.post(
      api_url("/repos/#{repo}/issues/#{pull_number}/labels"),
      [{"Authorization", "token #{github_token}"}],
      list_of_labels,
      []
    )

    {:noreply, state}
  end

  # --- private ---

  defp api_url(path) do
    {:ok, host} = Application.get_env(:secretary, :github_api)
    "#{host}#{path}"
  end

  defp github_token do
    {:ok, token} = Application.get_env(:secretary, :github_token)
    token
  end
end
