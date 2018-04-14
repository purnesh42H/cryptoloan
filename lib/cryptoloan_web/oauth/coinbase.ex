defmodule Coinbase do
  @moduledoc """
  An OAuth2 strategy for Coinbase.
  """
  use OAuth2.Strategy

  alias OAuth2.Strategy.AuthCode

  defp config do
    [strategy: Coinbase,
     site: "https://api.coinbase.com/v2/",
     authorize_url: "https://www.coinbase.com/oauth/authorize",
     token_url: "http://www.coinbase.com/oauth/token"]
  end

  # Public API

  def client do
    Application.get_env(:cryptoloan, Coinbase)
    |> Keyword.merge(config())
    |> OAuth2.Client.new()
  end

  def client(token) do
    %{client() | token: OAuth2.AccessToken.new(token) }
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], _headers \\ []) do
    headers = [{"Content-type", "application/json"}]
    params = Keyword.merge(params, client_id: client().client_id, redirect_uri: client().redirect_uri, client_secret: client().client_secret)
    params_map = %{"grant_type" => "authorization_code", "code" => to_string(params[:code]), "client_id" => to_string(params[:client_id]), "client_secret" => to_string(params[:client_secret]), "redirect_uri" => to_string(params[:redirect_uri])}
    {status, result} = JSON.encode(params_map)
    {status, response} = HTTPoison.post("https://api.coinbase.com/oauth/token", result, headers, [])
    response_map = Poison.decode!(response.body)
    client_instance = client()
    client_instance
    |> Map.put(:token, OAuth2.AccessToken.new(response_map))
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end
  
  def get_user(client) do
    authorization = Enum.join(["Bearer", to_string(client.token.access_token)], " ")
    {status, response} = HTTPoison.get("https://api.coinbase.com/v2/user", [{"Authorization", authorization}])
    Poison.decode!(response.body)
  end

  def get_accounts(client) do
    authorization = Enum.join(["Bearer", to_string(client.token.access_token)], " ")
    {status, response} = HTTPoison.get("https://api.coinbase.com/v2/accounts", [{"Authorization", authorization}])
    Poison.decode!(response.body)
  end
end
