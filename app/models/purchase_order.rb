class PurchaseOrder < ApplicationRecord
  has_many :invoices, dependent: :destroy
  belongs_to :contract # In order that Budget lines and P0 lines can be compared on PO show view
  has_many :po_lines, dependent: :destroy
  has_many :payments


  def self.ransackable_attributes(auth_object = nil)
      ["name", "description"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["name", "description","contract", "supplier"]
  end


  def calculate_spend
    self.spend = 0
    invoices.each do |invoice|
       self.spend += invoice.budget_price if !invoice.budget_price.nil?
    end
    save
  end

end
