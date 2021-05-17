defmodule ApiReg.Operations do
  alias ApiReg.Accounts
  alias ApiReg.Accounts.Account
  alias ApiReg.Repo
  # alias ApiReg.Transactions
  alias ApiReg.Transactions.Report
  alias Ecto.Multi

  @chargeback "chargeback"
  @deposit "deposit"
  @withdraw "withdraw"
  @transfer "transfer"

  def deposit(from, to_id, value) do
    verify_operation(from.balance, value, deposit_operation(from, to_id, value))
  end

  def transfer(from, to_id, value) do
    verify_operation(from.balance, value, transfer_operation(from, to_id, value))
  end

  def withdraw(from, value) do
    verify_operation(from.balance, value, withdraw_operation(from, value))
  end

  def chargeback(from, to_id, value) do
    verify_operation(from.balance, value, chargeback_operation(from, to_id, value))
  end

  defp deposit_operation(from, to_id, value) do
    to = Accounts.get!(to_id)

    Multi.new()
    |> Multi.update(:account_to, get_done_op(to, value, :sum))
    |> Multi.insert(:transaction, report_list(nil, value, from.id, to.id, @deposit))
    |> Repo.transaction()
    |> confirm_op("Deposit done successfully to #{to.id} value: #{value}")
  end

  def transfer_operation(from, to_id, value) do
    to = Accounts.get!(to_id)

    Multi.new()
    |> Multi.update(:account_from, get_done_op(from, value, :sub))
    |> Multi.update(:account_to, get_done_op(to, value, :sum))
    |> Multi.insert(:transaction, report_list(nil, value, from.id, to.id, @transfer))
    |> Repo.transaction()
    |> confirm_op("Transfer done successfully from #{from.id} to: #{to.id} value: #{value}")
  end

  defp withdraw_operation(from, value) do
    Multi.new()
    |> Multi.update(:account_from, get_done_op(from, value, :sub))
    |> Multi.insert(:transaction, report_list(nil, value, from.id, nil, @withdraw))
    |> Repo.transaction()
    |> confirm_op("Withdraw done successfully from #{from.id} value: #{value}")
  end

  def chargeback_operation(from, to_id, value) do
    to = Accounts.get!(to_id)

    Multi.new()
    |> Multi.update(:account_from, get_done_op(from, value, :sum))
    |> Multi.update(:account_to, get_done_op(to, value, :sub))
    |> Multi.insert(:transaction, report_list(nil, value, from.id, to.id, @chargeback))
    |> Repo.transaction()
    |> confirm_op("Chargeback done successfully from #{from.id} to: #{to.id} value: #{value}")
  end

  def get_done_op(account, value, :sub) do
    account
    |> balance_update(%{balance: Decimal.sub(account.balance, value)})
  end

  def get_done_op(account, value, :sum) do
    account
    |> balance_update(%{balance: Decimal.add(account.balance, value)})
  end

  def balance_update(%Account{} = account, attrs) do
    Account.changeset(account, attrs)
  end

  defp verify_operation(balance, value, operation) do
    case is_negative?(balance, value) do
      true ->
        {:error, "No funds to do this."}

      false ->
        operation
    end
  end

  defp is_negative?(from_balance, value) do
    Decimal.sub(from_balance, value)
    |> Decimal.negative?()
  end

  defp confirm_op(operations, msg) do
    case operations do
      {:ok, _} ->
        {:ok, msg}

      {:error, :account_from, changeset, _} ->
        {:error, changeset}

      {:error, :account_to, changeset, _} ->
        {:error, changeset}

      {:error, :transaction, changeset, _} ->
        {:error, changeset}
    end
  end

  defp report_list(id, value, from_id, to_id, type) do
    %Report{
      id: id,
      value: value,
      from: from_id,
      to: to_id,
      type: type,
      date: Date.utc_today()
    }
  end
end
