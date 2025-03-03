class Invoice < ApplicationRecord
  validates :name, presence: true
  has_many :orders, dependent: :destroy
  belongs_to :contract
  has_many :taxes, dependent: :destroy
  belongs_to :purchase_order, optional: true # allows us to remove value back to nil

  after_initialize :set_default_price


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

def gross
  self.invoice_price = 0
  orders.select{ |o| o.is_root? }.each do |order|
      self.invoice_price += order.calculate_gross  if  !order.calculate_gross.nil?
  end
  self.save
end

def net
  self.budget_price = 0
  orders.select{ |o| o.is_root? }.each do |order|
      self.budget_price += order.calculate_net if !order.calculate_net.nil?
  end
  self.save
end

def set_default_price
  self.invoice_price ||= 0
  self.budget_price ||= 0
end

end
