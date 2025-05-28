defmodule PlanterWeb.PageController do
  use PlanterWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
