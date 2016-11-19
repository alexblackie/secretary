defmodule Secretary.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  post "/" do
    {:ok, body, _} = Plug.Conn.read_body(conn)
    {_, signature} = List.keyfind(conn.req_headers, "x-hub-signature", 0)

    if Secretary.PayloadVerification.verify_webhook(signature, body) do
      Secretary.Ingestor.feed(body)
      send_resp(conn, 200, "")
    else
      send_resp(conn, 400, "Signatures did not match!")
    end
  end

  match _ do
    send_resp(conn, 404, "Error 404: Resource not found")
  end
end
