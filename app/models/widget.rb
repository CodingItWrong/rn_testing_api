# frozen_string_literal: true

class Widget < ApplicationRecord
  belongs_to :user

  validates :name, presence: true

  def to_json(*_args)
    {
      id: id,
      name: name,
    }
  end
end
