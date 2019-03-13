# Cryptoloan
Ever wondered taking advantage of money you have invested in cryptocurrencies? This application provides the solution. The web application which uses cryptocurrencies public APIs and JavaScript. The application uses cryptocurrencies as collateral for the loan provided by the peers and removes intermediaries like bank from the loaning system. 

## To Run
To start your Phoenix server:

  - Install dependencies with `mix deps.get`
  - Make changes to env-dev.sh as per your server and subscriptions
  - Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  - Install Node.js dependencies with `cd assets && npm install`
  - Run env-dev.sh
  - Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  - Official website: http://www.phoenixframework.org/
  - Guides: http://phoenixframework.org/docs/overview
  - Docs: https://hexdocs.pm/phoenix
  - Mailing list: http://groups.google.com/group/phoenix-talk
  - Source: https://github.com/phoenixframework/phoenix

## Highlighted Features

  - Get loan using BTC as colletaral
  - Real time notifications on BTC price
  - Search lenders by interest rates they are offering
  - Automatic deductions from buyer to lender after the agreed date based on current BTC rates
  - Pay back using BTC or cash. Your choice!
