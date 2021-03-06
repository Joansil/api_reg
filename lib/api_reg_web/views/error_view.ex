defmodule ApiRegWeb.ErrorView do
  use ApiRegWeb, :view

  alias Ecto.Changeset

  import Ecto.Changeset, only: [traverse_errors: 2]

  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  defp translate_errors(changeset) do
    traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  def render("400.json", %{reason: %Changeset{} = changeset}) do
    %{message: translate_errors(changeset)}
  end

  def render("400.json", %{reason: message}) do
    %{message: message}
  end
end
