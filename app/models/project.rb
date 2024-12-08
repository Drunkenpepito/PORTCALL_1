class Project < ApplicationRecord
  has_one :user
  has_one_attached :photo
  has_one :supplier
  has_one :purchase_order

  def self.ransackable_attributes(auth_object = nil)
    ["name", "description"]
  end
end
