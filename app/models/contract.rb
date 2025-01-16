class Contract < ApplicationRecord
    validates :name, presence: true
    has_many :services, dependent: :destroy
    has_many :tax_regimes, dependent: :destroy
    # has_one :supplier
    
    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "id", "id_value", "name", "updated_at"]
    end
    
    
    def totals
        services.each { |s| 
            s.has_children?   &&   s.formula == ""  &&   s.children.map(&:calculate).all? { |c| c != nil}?
            s.formula = s.children.sum(&:calculate).to_i   :   s.formula = "" }
    end
end