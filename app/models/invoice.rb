class Invoice < ApplicationRecord
  validates :name, presence: true
  has_many :orders, dependent: :destroy
  belongs_to :contract
  has_many :taxes, dependent: :destroy
  belongs_to :purchase_order, optional: true # allows us to remove value back to nil


  scope :with_supplier, ->(supplier) { where( supplier:) }


def price
  p =0
  self.orders.each do |o|
    p += o.invoice_price if o.is_root?
  end
  p
end

def budget
  p =0
  self.orders.each do |o|
    p += o.budget_price if o.is_root?
  end
  p
end


end
