defmodule Secretary.PayloadVerification do
  @moduledoc """
  This module provides a helper function for verifying the integrity of webhook
  payloads.
  """

  @doc """
  Given an expected hash, and the request body, determine if the body is valid.
  """
  @spec verify_webhook(String.t, String.t) :: Boolean.t
  def verify_webhook(theirs, body) do
    secret = Application.get_env(:secretary, :webhook_secret)
    computed_mac = :crypto.hmac(:sha, secret, body)
                    |> Base.encode16
                    |> String.downcase

    "sha1=#{computed_mac}" == theirs
  end

end
