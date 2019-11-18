defmodule CookieToJwtPlug do
  @moduledoc """
  Puts authorization token from cookies to Authorization headers and
  do refresh auth cookie.
  """

  import Plug.Conn

  require Logger

  def init(opts), do: opts

  @session_token_key Application.get_env(:cookie_to_jwt_plug, :session_token_key, "sessionToken")

  @max_cookie_age Application.get_env(:cookie_to_jwt_plug, :max_cookie_age, 24 * 60 * 60)

  @doc """
  Used as plug `call/2` callback to extract authorization token from cookies and
  put it into headers.
  """
  def call(%Plug.Conn{} = conn, _opts) do
    Logger.debug("Extracting cookies...")

    case fetch_session_token(conn) do
      {:ok, token} ->
        Logger.debug("Token found: #{token}")

        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> register_before_send(fn conn ->
          put_session_token(conn, token)
        end)

      :error ->
        Logger.debug("Token not found.")
        conn
    end
  end

  def fetch_session_token(%Plug.Conn{cookies: cookies}) do
    case cookies do
      %{@session_token_key => token} -> {:ok, token}
      _ -> :error
    end
  end

  @doc """
  Entry point for cookied connection.
  """
  def put_session_token(%Plug.Conn{} = conn, token) when is_binary(token) do
    cookie = "#{@session_token_key}=#{token}; Path=/; Max-Age=#{@max_cookie_age}"
    put_resp_header(conn, "set-cookie", cookie)
  end
end
