class Device < ApplicationRecord
  belongs_to :user
  validates :device_token, presence: true, uniqueness: {message: "This device has been created already"}
  validates :platform, presence: true, inclusion: {in: ["ios", "android"]}
end
