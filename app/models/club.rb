class Club < ApplicationRecord
    has_one_attached :logo
    has_many :roles
end
