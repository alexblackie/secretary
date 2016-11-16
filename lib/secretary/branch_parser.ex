defmodule Secretary.BranchParser do
  @moduledoc """
  Functions for parsing branch names and determining labels for them.
  """

  @doc """
  Given the branch name `branch`, return a list of labels applicable to that
  branch. Currently, this just returns the branch category
  """
  def labels(branch) do
    case Regex.named_captures(~r/^(?<category>[\w-_]+)\/.+$/, branch) do
      %{"category" => category} ->
        List.wrap(category)
      _ ->
        []
    end
  end
end
