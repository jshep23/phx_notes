defmodule Notes.Repository.DadJokeRepo do
  def get_joke() do
    # This is a simple HTTP request to get a dad joke
    # This is also unsafe and assumes the request will always succeed
    Req.get!("https://icanhazdadjoke.com/", headers: [{"Accept", "text/plain"}]).body
  end
end
