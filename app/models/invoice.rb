class Invoice < ApplicationRecord
  validates :name, presence: true
  has_many :orders, dependent: :destroy
  belongs_to :contract
  has_many :taxes, dependent: :destroy
  belongs_to :purchase_order, optional: true # allows us to remove value back to nil


  scope :with_supplier, ->(supplier) { where( supplier:) }

def self.ransackable_attributes(auth_object = nil)
    ["name", "description"]
end
def self.ransackable_associations(auth_object = nil)
  ["name", "description"]
end

def price
  # ATTENTION DANGEREUX , IL VA AFFCHER UNE VALEUR DE PRICE MEME SI UN ORDER N'A PAS DE INVOICE PRICE 
  p = 0
  self.orders.each do |o|
    p += o.invoice_price if o.is_root? && o.invoice_price != nil
  end
  p
end

def budget
  p =0
  self.orders.each do |o|
    p += o.budget_price if o.is_root? && o.budget_price != nil
  end
  p
end


end
