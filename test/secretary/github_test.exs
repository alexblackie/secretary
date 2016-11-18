defmodule Secretary.GithubTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  describe "label_issue/3" do
    test "a successful request" do
      use_cassette("github_post_labels") do
        {:ok, body} = Secretary.Github.label_issue(["bug"], "alexblackie/secretary", "1")
        assert is_binary(body)
        assert(
          Poison.decode!(body)
          |> List.first
          |> Map.fetch!("name")
          |> Kernel.==("bug")
        )
      end
    end
  end
end
