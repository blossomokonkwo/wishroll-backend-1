class BoardPost < ApplicationRecord
  belongs_to :board_member
  belongs_to :board
  belongs_to :post
end
