defmodule ApiReg.Transactions do
  alias ApiReg.Repo
  alias ApiReg.Transactions.Report

  import Ecto.Query, warn: false

  def all do
    Repo.all(Report)
    |> report_pay()
  end

  def year(year) do
    search(Date.from_erl!({year, 01, 01}), Date.from_erl!({year, 12, 31}))
  end

  def search(start_date, end_date) do
    query = from r in Report, where: r.date >= ^start_date and r.date <= ^end_date

    Repo.all(query)
    |> report_pay()
  end

  def month(year, month) do
    start_date = Date.from_erl!({year, month, 01})
    days_in_month = start_date |> Date.days_in_month()
    end_date = Date.from_erl!({year, month, days_in_month})

    search(start_date, end_date)
  end

  def day(day) do
    query = from r in Report, where: r.date == ^Date.from_iso8601!(day)

    Repo.all(query)
    |> report_pay()
  end

  def report_pay(transactions) do
    %{
      total: total(transactions),
      transactions: transactions
    }
  end

  def total(transactions) do
    Enum.reduce(transactions, Decimal.new("0"), fn t, acc ->
      Decimal.add(acc, t.value)
    end)
  end

  def get_transaction!(id), do: Repo.get!(Report, id)

  def create_transaction(attrs \\ %{}) do
    %Report{}
    |> Report.changeset(attrs)
    |> Repo.insert()
  end

  def insert_transaction(attrs \\ %{}) do
    %Report{}
    |> Report.changeset(attrs)
    |> Repo.insert()
  end

  def update_transaction(%Report{} = transaction, attrs) do
    transaction
    |> Report.changeset(attrs)
    |> Repo.update()
  end

  def delete_transaction(%Report{} = transaction) do
    Repo.delete(transaction)
  end

  def change_transaction(%Report{} = transaction, attrs \\ %{}) do
    Report.changeset(transaction, attrs)
  end
end
