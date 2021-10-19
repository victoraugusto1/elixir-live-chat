defmodule LiveChatWeb.RoomController do
  use LiveChatWeb, :controller

  def new(conn, _params) do
    room_name = "/room/" <> MnemonicSlugs.generate_slug(4)
    redirect(conn, to: room_name)
  end
end
