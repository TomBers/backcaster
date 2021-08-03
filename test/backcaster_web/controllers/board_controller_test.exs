#defmodule BackcasterWeb.BoardControllerTest do
#  use BackcasterWeb.ConnCase
#
#  import Backcaster.BackcastFixtures
#
#  alias Backcaster.Backcast.Board
#
#  @create_attrs %{
#    content: %{},
#    name: "some name"
#  }
#  @update_attrs %{
#    content: %{},
#    name: "some updated name"
#  }
#  @invalid_attrs %{content: nil, name: nil}
#
#  setup %{conn: conn} do
#    {:ok, conn: put_req_header(conn, "accept", "application/json")}
#  end
#
#  describe "index" do
#    test "lists all boards", %{conn: conn} do
#      conn = get(conn, Routes.board_path(conn, :index))
#      assert json_response(conn, 200)["data"] == []
#    end
#  end
#
#  describe "create board" do
#    test "renders board when data is valid", %{conn: conn} do
#      conn = post(conn, Routes.board_path(conn, :create), board: @create_attrs)
#      assert %{"id" => id} = json_response(conn, 201)["data"]
#
#      conn = get(conn, Routes.board_path(conn, :show, id))
#
#      assert %{
#               "id" => ^id,
#               "content" => %{},
#               "name" => "some name"
#             } = json_response(conn, 200)["data"]
#    end
#
#    test "renders errors when data is invalid", %{conn: conn} do
#      conn = post(conn, Routes.board_path(conn, :create), board: @invalid_attrs)
#      assert json_response(conn, 422)["errors"] != %{}
#    end
#  end
#
#  describe "update board" do
#    setup [:create_board]
#
#    test "renders board when data is valid", %{conn: conn, board: %Board{id: id} = board} do
#      conn = put(conn, Routes.board_path(conn, :update, board), board: @update_attrs)
#      assert %{"id" => ^id} = json_response(conn, 200)["data"]
#
#      conn = get(conn, Routes.board_path(conn, :show, id))
#
#      assert %{
#               "id" => ^id,
#               "content" => %{},
#               "name" => "some updated name"
#             } = json_response(conn, 200)["data"]
#    end
#
#    test "renders errors when data is invalid", %{conn: conn, board: board} do
#      conn = put(conn, Routes.board_path(conn, :update, board), board: @invalid_attrs)
#      assert json_response(conn, 422)["errors"] != %{}
#    end
#  end
#
#  describe "delete board" do
#    setup [:create_board]
#
#    test "deletes chosen board", %{conn: conn, board: board} do
#      conn = delete(conn, Routes.board_path(conn, :delete, board))
#      assert response(conn, 204)
#
#      assert_error_sent 404, fn ->
#        get(conn, Routes.board_path(conn, :show, board))
#      end
#    end
#  end
#
#  defp create_board(_) do
#    board = board_fixture()
#    %{board: board}
#  end
#end
