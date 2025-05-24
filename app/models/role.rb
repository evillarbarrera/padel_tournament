class Role < ApplicationRecord
  belongs_to :user
  belongs_to :club

  validates :nombre, presence: true
end
