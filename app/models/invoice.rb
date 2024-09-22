class Invoice < ApplicationRecord
  validates :name, presence: true
  has_many :orders, dependent: :destroy
  belongs_to :contract
  has_many :taxes, dependent: :destroy


def price
  p =0
  self.orders.each do |o|
    p += o.invoice_price if o.is_root?
  end
  p
end

end
