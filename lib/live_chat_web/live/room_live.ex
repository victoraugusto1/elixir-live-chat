defmodule LiveChatWeb.RoomLive do
  use LiveChatWeb, :live_view
  require Logger

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    topic = "room:" <> room_id
    username = MnemonicSlugs.generate_slug(1)
    if connected?(socket) do
      LiveChatWeb.Endpoint.subscribe(topic)
      LiveChatWeb.Presence.track(
        self(),
        topic,
        username,
        %{}
      )
    end
    {:ok,
    assign(socket,
      room_id: room_id,
      topic: topic,
      messages: [ ],
      users_online: []
    )}
  end

  @impl true
  def handle_event("random-room", _session, socket) do
    room_name = "/room/" <> MnemonicSlugs.generate_slug(4)
    {:noreply, push_redirect(socket, to: room_name)}
  end

  @impl true
  def handle_event("send_message", %{"chat" => %{"message" => message}}, socket) do
    message_to_broadcast = %{uuid: UUID.uuid4(), content: message}
    Logger.info("Sending message: " <> message)
    LiveChatWeb.Endpoint.broadcast(socket.assigns.topic, "new-message", message_to_broadcast)
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "new-message", payload: message}, socket) do
    {:noreply, assign(socket, messages: [message])}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: %{joins: users_joining, leaves: users_leaving}}, socket) do
    join_messages = users_joining
    |> Map.keys()
    |> Enum.map(fn(username) -> %{uuid: UUID.uuid4(), content: "#{username} has joined the chat"} end)

    leave_messages = users_leaving
    |> Map.keys()
    |> Enum.map(fn(username) -> %{uuid: UUID.uuid4(), content: "#{username} has left the chat"} end)

    users_online = socket.assigns.topic
    |> LiveChatWeb.Presence.list()
    |> Map.keys()

    IO.inspect(users_online)

    {:noreply, assign(socket, messages: join_messages ++ leave_messages, users_online: users_online)}
  end

end
