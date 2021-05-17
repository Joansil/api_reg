# ApiReg

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

First of all, you have to generate your .env with the command source .env and get the guardian secret.


To create a new user, you have to make sign_up and send the parameters:

curl X POST "http://localhost:4000/auth/sign_up" -H "accept: application/json" -H "content-type: application/json" -d "{ \"user\": {\"cpf\": \valid cpf\, \"name\": \"Test\", \"last_name\": \"Testando\", \"password\": \"123456\" }}"


And it will generate the response:

{
  "account_id": "1206eb6c-e1e3-487a-8213-cbf9483e2435",
  "balance": 0,
  "user": {
    "cpf": "some valid cpf here",
    "id": "8cd92644-eeae-4720-b550-bd36447e6d00",
    "last_name": "Testando",
    "name": "Test",
    "role": "user"
  }
}

If you try create an user without any parameters you get this:


   {"errors":{"cpf":["Invalid Cpf"],"last_name":["Last name have to be only letters."],"name":["can't be blank"],"password":["can't be blank"]}}
   
   if you try repeat the cpf:
   
   {"errors":{"cpf":["Have to be just one Cpf for each user"]}}
    


And others validations...

After, you have to make sign_in, to take your token

{
  "data": {
    "account": {
      "balance": "0",
      "id": "817b5bdc-3e76-48e2-9ada-9dbcea3ff7cd"
    },
    "cpf": "948756338",
    "id": "b44819c5-0790-44d1-93c2-1008bbfc8118",
    "last_name": "Testando",
    "name": "Test",
    "role": "user",
    "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGlfcmVnIiwiZXhwIjoxNjIzNjc4NTUyLCJpYXQiOjE2MjEyNTkzNTIsImlzcyI6ImFwaV9yZWciLCJqdGkiOiI1ZmI2YzJkZi05NGYyLTRiMDktOTdjYS1lNWU2ZWRiYjFmODIiLCJuYmYiOjE2MjEyNTkzNTEsInN1YiI6ImI0NDgxOWM1LTA3OTAtNDRkMS05M2MyLTEwMDhiYmZjODExOCIsInR5cCI6ImFjY2VzcyJ9.6l6sEv-0xqxr-BfXmeuymnPVTW_mMq7byQNZhg4nlLCJzSr6RjD2L6DXgsqlZ-22bYnnzO-ADB4chxpsdX5yIg"
  }
}

To make a deposit, you can send the parameters with the Bearer token Authorization. You can deposit to your own account and others, just put the account id and the value.

curl X POST "http://localhost:4000/auth/operations/deposit" -H "accept: application/json" -H "content-type: application/json" -H "Authorization:Bearer token here" -d "{ \"to\": \"817b5bdc-3e76-48e2-9ada-9dbcea3ff7cd\" \"value\": \"300.00\" }"

And then you get this response:

{
  "message": "Deposit done successfully to 817b5bdc-3e76-48e2-9ada-9dbcea3ff7cd value: 300"
}

And with the withdraw, you just put the value.


curl X POST "http://localhost:4000/auth/operations/withdraw" -H "accept: application/json" -H "content-type: application/json" -H "Authorization:Bearer token here" -d "{ \"value\": \"50.00\" }"

And then you get this response:

{
  "message": "Withdraw done successfully from 817b5bdc-3e76-48e2-9ada-9dbcea3ff7cd value: 50"
}

To make a transfer, you have to had more than 1 user, so you can create another one, and take these account id to make: to => id, just like this:

curl X POST "http://localhost:4000/auth/operations/transfer" -H "accept: application/json" -H "content-type: application/json" -H "Authorization:Bearer token here" -d "{ \"to\": \"a41db0a9-34a6-42b6-8853-dc27d7e735d1\", \"value\": \"30.00\" }"

And your response will be:

{
  "message": "Transfer done successfully from 817b5bdc-3e76-48e2-9ada-9dbcea3ff7cd to: 45c7c807-dc6f-4b63-8fe6-01d39cabdeed value: 30"
}


To make a chargeback:

POST http://localhost:4000/auth/operations/chargeback

{
  "message": "Chargeback done successfully from 817b5bdc-3e76-48e2-9ada-9dbcea3ff7cd to: 45c7c807-dc6f-4b63-8fe6-01d39cabdeed value: 280"
}

If you try make any operation without an Authorization:

curl X POST "http://localhost:4000/auth/operations/transfer" -H "accept: application/json" -H "content-type: application/json" -H  -d "{ \"to\": \"a41db0a9-34a6-42b6-8853-dc27d7e735d1\", \"value\": \"30.00\" }"

You get this:

{
  "error": "You don't have authorization to do this."
}


To see your own account and balance you have to do

GET http://localhost:4000/auth/user

{
  "data": {
    "account": {
      "balance": "2000",
      "id": "817b5bdc-3e76-48e2-9ada-9dbcea3ff7cd"
    },
    "cpf": "948756338",
    "id": "b44819c5-0790-44d1-93c2-1008bbfc8118",
    "last_name": "Testando",
    "name": "Test",
    "role": "user"
  }
}

To see all users you have to be admin role. To do this, you put the role in sign_up creation

curl X POST "http://localhost:4000/auth/sign_up" -H "accept: application/json" -H "content-type: application/json" -d "{ \"user\": {\"cpf\": \valid cpf\, \"name\": \"Admin\", \"last_name\": \"Admin\", \"password\": \"123456\", \"role\": \"admin\" }}"

And get your admin token in sign_in route, to see all users

To see the all transactions you have to go in 

GET http://localhost:4000/auth/transactions/all 

And to see with specific dates:

GET "/transactions/year/:year" where :year you put the year i.e: 2021

GET "/transactions/year/:year/month/:month" :year you put the year i.e: 2021 and :month the month i.e: 05

GET "/transactions/day/:day" :day you put the year i.e: 2021-05-17


Development
You need to define the environment variable DATABASE_URL with yout database connection string for PostgreSQL:

$ export DATABASE_URL="postgres://api_reg:api_reg@database:5432/api_reg"
$ iex -S mix phx.server

Tests
You can run all tests locally using the command:

$ mix setup                   # Create database
$ mix test --trace            # Run the tests (its not complete cover...)

Contributing
To contribute you need to:

    * Fork this repo
    * Create a new branch, i.e.: feature/awesome-commit
    * Push your code to your fork
    * Create a pull-request to this repo
    * Await to code review sparkles

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
