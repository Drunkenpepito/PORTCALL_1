class PurchaseOrder < ApplicationRecord
  has_many :invoices
end
