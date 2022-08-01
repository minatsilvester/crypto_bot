defmodule CryptoBot.Bot do
  @bot :crypto_bot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  use Tesla
  plug Tesla.Middleware.BaseUrl, "https://api.coingecko.com/api/v3/"

  command("start")
  command("help", description: "Print the bot's help")
  command("list", description: "List all the tokens")
  command("ids", description: "List all supported ids")
  command("price", description: "Get the price of a token")

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, :start, _msg}, context) do
    answer(context, welcome())
  end

  def handle({:command, :help, _msg}, context) do
    answer(context, get_help())
  end

  def handle({:command, :price, msg}, context) do
    {:ok, response} = get_price(msg.text)
    body = Jason.decode!(response.body)
    answer(context, "The price for #{msg.text} is #{body["bitcoin"]["usd"]} usd")
  end

  def handle({:command, :list, _msg}, context) do
    {:ok, response} = get_tokens()
    IO.inspect(response.body)
    answer(context, Jason.decode!(response.body) |> Enum.join("\n"))
  end

  def handle({:command, :ids, _msg}, context) do
    {:ok, response} = get_ids()
    required_symbols = Jason.decode!(response.body) |> Enum.map(fn to -> to["id"] end) |> Enum.take(10)
    answer(context, required_symbols |> Enum.join("\n"))
  end

  # "https://api.coingecko.com/api/v3/simple/supported_vs_currencies"

  def welcome do
    """
    This is a bot that can fetch you
    information on crypto tokens
    """
  end

  def get_help do
    """
      This bot has the following commands
      /start - Get Bot's Introduction
      /list - List all supported token's symbol
      /ids - List all supported Ids
      /price - Get the price of given token
    """
  end

  def get_tokens do
    get("simple/supported_vs_currencies")
  end

  def get_ids do
    get("coins")
  end

  def get_price(token_id) do
    get("simple/price?ids=#{token_id}&vs_currencies=usd")
  end
end
