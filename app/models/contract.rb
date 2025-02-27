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
end