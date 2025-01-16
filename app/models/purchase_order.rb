class PurchaseOrder < ApplicationRecord
  has_many :invoices


  def self.ransackable_attributes(auth_object = nil)
      ["name", "description"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["name", "description"]
  end

end
