class Supplier < ApplicationRecord
  before_validation :set_cw
  has_many :contracts

  # validation
  validates :description, presence: true, length: { maximum: 500 }
  validates :contact, presence: true
  validates :cw, inclusion: { in: [true, false] }

  private

  def set_cw
    self.cw = false if cw.nil?
  end
end
