# frozen_string_literal: true

class Widget < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
end
