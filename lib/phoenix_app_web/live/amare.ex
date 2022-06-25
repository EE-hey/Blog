defmodule PhoenixAppWeb.Amare do
    use Phoenix.LiveView
  
    @topic "msg"
  
    def render(assigns) do
        ~L""" 
        <h1>Etienne's Live chat ! </h1>

            <label>Mon message : <input type='text' phx-keydown='envoyer_message' name='mon_message'></label>
            <p><%= @raised %></p>
            
         </div>
        """
    end
  
 
    def mount(params, session, socket) do
        PhoenixAppWeb.Endpoint.subscribe(@topic)
        {:ok, assign(socket, :raised, "")}
    end
    def handle_event("envoyer_message", %{"key" => key, "value" => value}, socket) do
        raised =  value <> key
        PhoenixAppWeb.Endpoint.broadcast_from(self(), @topic, "envoyer_message", raised)
        {:noreply, assign(socket, :raised, raised)}
    end
    def handle_info(%{topic: @topic, payload: raised}, socket) do
        {:noreply, assign(socket, :raised, raised)}
    end
  end