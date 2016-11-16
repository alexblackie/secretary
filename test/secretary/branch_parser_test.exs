defmodule Secretary.BranchParserTest do
  use ExUnit.Case, async: true

  alias Secretary.BranchParser

  describe "labels/1" do
    test "with a feature branch" do
      assert BranchParser.labels("feature/great_things") == ["feature"]
    end

    test "with a hyphenated category" do
      assert BranchParser.labels("extremely-urgent/fixme-right-now") == ["extremely-urgent"]
    end

    test "with an underscored category" do
      assert BranchParser.labels("extremely_urgent/youre_still_good") == ["extremely_urgent"]
    end

    test "with a non-word prefix" do
      assert BranchParser.labels("e=mc™/sure_i_guess") == []
    end

    test "with a naked branch" do
      assert BranchParser.labels("i_am_bad") == []
    end
  end
end
