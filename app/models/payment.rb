class Payment < ApplicationRecord
  belongs_to :purchase_order
  has_one :invoice

  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
end
