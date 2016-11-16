defmodule Secretary.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  post "/" do
    {:ok, body, _} = Plug.Conn.read_body(conn)
    Secretary.Ingestor.feed(body)
    send_resp(conn, 200, "")
  end

  match _ do
    send_resp(conn, 404, "Error 404: Resource not found")
  end
end
