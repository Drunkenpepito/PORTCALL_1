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

  def calculate_invoice_price
    self.invoice_price = 0
    orders.select{ |o| o.is_root? }.each do |order|
        self.invoice_price += order.gross  if  !order.gross.nil?
    end
    save
  end

  def calculate_budget_price
    self.budget_price = 0
    orders.select{ |o| o.is_root? }.each do |order|
        self.budget_price += order.net if !order.net.nil?
    end
    save
  end

  def set_default_price
    self.invoice_price ||= 0
    self.budget_price ||= 0
  end

end
