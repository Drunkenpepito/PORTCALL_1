class Tax < ApplicationRecord
  belongs_to :invoice
  has_and_belongs_to_many :orders
end
