class Contract < ApplicationRecord
    validates :name, presence: true
    has_many :services, dependent: :destroy
    has_many :tax_regimes, dependent: :destroy
    # has_one :supplier
end


def totals
    services.each { |s| 
        s.has_children?   &&   s.formula == ""  &&   s.children.map(&:calculate).all? { |c| c != nil}?
        s.formula = s.children.sum(&:calculate).to_i   :   s.formula = "" }
end