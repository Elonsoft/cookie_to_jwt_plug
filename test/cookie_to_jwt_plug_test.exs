defmodule CookieToJwtPlugTest do
  @moduledoc false

  use ExUnit.Case

  @unique_token Base.encode32(:crypto.hash(:sha256, "token"))

  describe "`put_session_token`" do
    setup do
      [conn: %Plug.Conn{}]
    end

    test "puts provided token into cookie", %{conn: conn} do
      assert %{resp_headers: headers} = CookieToJwtPlug.put_session_token(conn, @unique_token)
      assert {"set-cookie", cookie} = Enum.find(headers, &(elem(&1, 0) == "set-cookie"))
      assert cookie =~ @unique_token
    end
  end

  describe "`call`" do
    setup do
      conn = %Plug.Conn{cookies: %{"sessionToken" => @unique_token}}
      [conn: conn]
    end

    test "puts received token into Authorization header", %{conn: conn} do
      assert %{req_headers: headers} = CookieToJwtPlug.call(conn, [])
      assert {"authorization", header} = Enum.find(headers, &(elem(&1, 0) == "authorization"))
      assert "Bearer #{@unique_token}" = header
    end
  end
end
