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
  ["name", "description", "contract", "supplier"]
end

# def price
#   # ATTENTION DANGEREUX , IL VA AFFCHER UNE VALEUR DE PRICE MEME SI UN ORDER N'A PAS DE INVOICE PRICE 
#   p = 0
#   self.orders.each do |o|
#     p += o.invoice_price if o.is_root? && o.invoice_price != nil
#   end
#   p
# end

# def budget
#   p =0
#   self.orders.each do |o|
#     p += o.budget_price if o.is_root? && o.budget_price != nil
#   end
#   p
# end
# 

def calculate_gross
  invoice_price = 0
  orders.each do |order|
    invoice_price += order.calculate_gross if order.is_root? && !order.calculate_gross.nil?
  end
  save
end

def calculate_net
  budget_price = 0
  orders.each do |order|
    budget_price += order.calculate_net if order.is_root? && !order.calculate_net.nil?
  end
  save
end


end
