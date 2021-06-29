require "test_helper"

class BoardTest < ActiveSupport::TestCase
  test "validates_presence_of_name" do
    board = Board.new
    assert_not board.save
  end

    test "validates_uniqueness_of_name" do
      board_name = "Board Name"
      board1 = Board.new(name: board_name)
      board1.save
      board2 = Board.new(name: board_name)
      assert_exception board2.save!
    end
end
