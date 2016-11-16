defmodule Secretary.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  post "/" do
    # TODO implement
    send_resp(conn, 200, "")
  end

  match _ do
    send_resp(conn, 404, "Error 404: Resource not found")
  end
end
