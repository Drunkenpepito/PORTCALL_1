class Payment < ApplicationRecord
  belongs_to :purchase_order
  has_one :invoice
end
