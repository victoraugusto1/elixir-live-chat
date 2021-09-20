defmodule LiveChatWeb.RoomLive do
  use LiveChatWeb, :live_view
  require Logger

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    topic = "room:" <> room_id
    if connected?(socket), do: LiveChatWeb.Endpoint.subscribe(topic)
    {:ok,
    assign(socket,
      room_id: room_id,
      topic: topic,
      messages: [%{uuid: UUID.uuid4(), content: "User joined the chat"}]
    )}
  end

  @impl true
  def handle_event("random-room", _session, socket) do
    random_slug = "/" <> MnemonicSlugs.generate_slug(4)
    {:noreply, push_redirect(socket, to: random_slug)}
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
end
