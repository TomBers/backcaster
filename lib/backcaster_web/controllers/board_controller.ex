defmodule BackcasterWeb.BoardController do
  use BackcasterWeb, :controller

  alias Backcaster.Backcast
  alias Backcaster.Backcast.Board
  alias Backcaster.SampleData


  action_fallback BackcasterWeb.FallbackController

  def create_new(conn, _params) do
    id = Ecto.UUID.generate()
    goal_date =
      Date.utc_today()
      |> Date.add(31)

    Backcast.get_or_create_board!(id, SampleData.simple())

    redirect(conn, to: "/backcast/#{id}")
  end

  def create_new(conn, _params) do
    redirect(conn, to: "/")
  end

  def index(conn, _params) do
    boards = Backcast.list_boards()
    render(conn, "index.json", boards: boards)
  end

  def create(conn, %{"board" => board_params}) do
    with {:ok, %Board{} = board} <- Backcast.create_board(board_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.board_path(conn, :show, board))
      |> render("show.json", board: board)
    end
  end

  def show(conn, %{"id" => id}) do
    board = Backcast.get_board!(id)
    render(conn, "show.json", board: board)
  end

  def update(conn, %{"id" => id, "board" => board_params}) do
    board = Backcast.get_board!(id)

    with {:ok, %Board{} = board} <- Backcast.update_board(board, board_params) do
      render(conn, "show.json", board: board)
    end
  end

  def delete(conn, %{"id" => id}) do
    board = Backcast.get_board!(id)

    with {:ok, %Board{}} <- Backcast.delete_board(board) do
      send_resp(conn, :no_content, "")
    end
  end
end
