# CookieToJwtPlug

Puts authorization token from cookies to Authorization headers and
do refresh auth cookie.

You can put it in your Guardian pipline and think that you're working
with just jwt token.

```elixir
defmodule YourApp.Guardian.Pipeline do
  @moduledoc false

  use Guardian.Plug.Pipeline,
    otp_app: :your_app,
    error_handler: YourApp.Guardian.ErrorHandler,
    module: YourApp.Guardian

  # Extract token from cookies.
  plug CookieToJwtPlug

  # If there is a session token, restrict it to an access token and validate it
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  # If there is an authorization header, restrict it to an access token
  # and validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true
end
```

And also you should put your cookies on authorization:

```elixir
defmodule YourAppWeb.SomeController do
  @moduledoc false

  # The function that authenticate a user and returns a token for her.
  import Auth, only: [authenticate_user: 1]

  def login(conn, params) do
    with {:ok, token} <- authenticate_user(params) do
      conn
      |> CookieToJwtPlug.put_session_token(token)
      |> render("index.html")
    end
  end
end
```

## Installation

Add this to your deps:

```elixir
def deps do
  [
    {:cookie_to_jwt_plug, "~> 0.1"}
  ]
end
```
