class PurchaseOrder < ApplicationRecord
  has_many :invoices
  belongs_to :contract # In order that Budget lines and P0 lines can be compared on PO show view
  has_many :po_lines, dependent: :destroy
  has_many :payments


  def self.ransackable_attributes(auth_object = nil)
      ["name", "description"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["name", "description"]
  end

end
