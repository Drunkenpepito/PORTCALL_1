class TaxRegime < ApplicationRecord
  belongs_to :contract
  has_and_belongs_to_many :services
end
