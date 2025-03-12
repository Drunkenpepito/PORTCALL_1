class Contract < ApplicationRecord
    validates :name, presence: true
    has_many :services, dependent: :destroy
    has_many :tax_regimes, dependent: :destroy
    has_many :invoices
    has_many :purchase_orders
    belongs_to :supplier
    
    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "id", "id_value", "name", "updated_at"]
    end

    
    def self.ransackable_associations(auth_object = nil)
      ["name", "supplier"]
    end
    
    
    def totals
        services.each { |s| 
            s.has_children?   &&   s.formula == ""  &&   s.children.map(&:calculate).all? { |c| c != nil}?
            s.formula = s.children.sum(&:calculate).to_i   :   s.formula = "" }
    end

    def display_name
        "#{name} - #{supplier.name}" if supplier.present?
    end


    # def calculate_contract_invoice_price
    #     self.invoice_price = 0
    #     orders.select{ |o| o.is_root? }.each do |order|
    #         self.invoice_price += order.gross  if  !order.gross.nil?
    #     end
    #     save
    #   end
    
    #   def calculate_contract_budget_price
    #     self.budget_price = 0
    #     orders.select{ |o| o.is_root? }.each do |order|
    #         self.budget_price += order.net if !order.net.nil?
    #     end
    #     save
    #   end
end