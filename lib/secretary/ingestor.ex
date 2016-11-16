defmodule Secretary.Ingestor do
  use GenServer

  def start_link(args) do
    {:ok, _} = GenServer.start_link(__MODULE__, args, name: {:global, __MODULE__})
  end

  def feed(payload) do
    GenServer.cast(__MODULE__, {:feed, payload})
  end

  # ---

  def handle_cast({:feed, payload}, state) do
    # TODO:
    #   - parse json payload
    #   - make request to github api for labels matching branch
    {:noreply, state}
  end
end
