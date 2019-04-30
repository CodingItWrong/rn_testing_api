class Widget < ApplicationRecord
  belongs_to :user

  validates :name, required: true
end
