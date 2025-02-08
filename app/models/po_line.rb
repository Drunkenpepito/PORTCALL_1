class PoLine < ApplicationRecord
  belongs_to :purchase_order
  validates :name, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 0 }
end
