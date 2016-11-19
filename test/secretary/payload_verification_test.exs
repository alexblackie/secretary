defmodule Secretary.PayloadVerificationTest do
  use ExUnit.Case, async: true
  alias Secretary.PayloadVerification, as: Subject

  describe "verify_webhook/2" do
    test "with a valid hash" do
      theirs = "sha1=a356ca3fe318c1642df1cc3aab9b8624cdf20059"
      {:ok, body} = File.read("test/fixtures/verification_payload.json")
      assert Subject.verify_webhook(theirs, body)
    end
  end
end
