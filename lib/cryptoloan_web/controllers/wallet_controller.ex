defmodule CryptoloanWeb.WalletController do
  use CryptoloanWeb, :controller

  alias Cryptoloan.Wallets
  alias Cryptoloan.Wallets.Wallet

  alias Cryptoloan.Users
  alias Cryptoloan.Users.User

  action_fallback CryptoloanWeb.FallbackController

  def index(conn, _params) do
    wallets = Wallets.list_wallets()
    render(conn, "index.json", wallets: wallets)
  end

  def create(conn, %{"wallet" => wallet_params}) do
    with {:ok, %Wallet{} = wallet} <- Wallets.create_wallet(wallet_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", wallet_path(conn, :show, wallet))
      |> render("show.json", wallet: wallet)
    end
  end

  def show(conn, %{"id" => id}) do
    wallet = Wallets.get_wallet!(id)
    render(conn, "show.json", wallet: wallet)
  end

  def update(conn, %{"id" => id, "wallet" => wallet_params}) do
    wallet = Wallets.get_wallet!(id)

    with {:ok, %Wallet{} = wallet} <- Wallets.update_wallet(wallet, wallet_params) do
      render(conn, "show.json", wallet: wallet)
    end
  end

  def delete(conn, %{"id" => id}) do
    wallet = Wallets.get_wallet!(id)
    with {:ok, %Wallet{}} <- Wallets.delete_wallet(wallet) do
      send_resp(conn, :no_content, "")
    end
  end
  
  def by_user(conn, params) do
    user = Users.get_user!(params["user_id"])
    client = %{token: %{access_token: user.token}}
    accounts = Coinbase.get_accounts(client)
    if !accounts do
      send_resp(conn, :no_content, "")
    else
      wallet = Wallets.get_user_wallet(params["user_id"])
      render(conn, "show.json", wallet: wallet)
    end
  end
  
  def send_btc(conn, %{"sender_id" => sender_id, "receiver_id" => receiver_id, "amount" => amount}) do
    sender = Users.get_user!(sender_id)
    receiver = Users.get_user!(receiver_id)
    sender_token = Coinbase.refresh_token(sender.refresh_token)
    receiver_token  = Coinbase.refresh_token(receiver.refresh_token)
    Users.update_user(sender, %{token: sender_token["access_token"], refresh_token: sender_token["refresh_token"]}) 
    Users.update_user(receiver, %{token: receiver_token["access_token"], refresh_token: receiver_token["refresh_token"]})
    sender_wallet = Wallets.get_user_wallet(sender_id)
    receiver_wallet = Wallets.get_user_wallet(receiver_id)
    addresses = Coinbase.get_addresses(receiver_wallet.user.token, receiver_wallet.account_id)
    if addresses do
      first_address = hd(addresses["data"])
      transaction = Coinbase.post_transaction(sender_wallet.user.token, sender_wallet.account_id, first_address["address"], amount, "BTC")
      if transaction do
        if (sender_wallet.balance - amount >= 0) do
          Wallets.update_wallet(sender_wallet, %{balance: sender_wallet.balance - amount})
          Wallets.update_wallet(receiver_wallet, %{balance: receiver_wallet.balance + amount})
        end
        render(conn, "show.json", wallet: Wallets.get_wallet!(sender_wallet.id))
      else
        send_resp(conn, :no_content, "")
      end
    else
      send_resp(conn, :no_content, "")
    end
  end
end 
