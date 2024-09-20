class Invoice < ApplicationRecord
  validates :name, presence: true
  has_many :orders, dependent: :destroy
  belongs_to :contract
  has_many :taxes
end
