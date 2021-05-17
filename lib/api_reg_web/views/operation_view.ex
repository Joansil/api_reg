defmodule ApiRegWeb.OperationView do
  use ApiRegWeb, :view

  def render("success.json", %{message: message}) do
    %{
      message: message
    }
  end
end
