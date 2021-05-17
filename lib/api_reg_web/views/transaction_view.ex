defmodule ApiRegWeb.TransactionView do
  use ApiRegWeb, :view

  def render("show.json", %{operation: operation}) do
    %{data: render_one(operation, __MODULE__, "operation.json")}
  end

  def render("operation.json", %{operation: operation}) do
    report_operations =
      Enum.map(operation.transactions, fn o ->
        %{
          id: o.id,
          value: o.value,
          from: o.from,
          to: o.to,
          type: o.type,
          date: o.date
        }
      end)

    %{
      report_operations: report_operations,
      total_operations: operation.total
    }
  end
end
