class Role < ApplicationRecord
  belongs_to :user
  belongs_to :club, optional: true

  validates :nombre, presence: true
  validates :estado, presence: true
end
