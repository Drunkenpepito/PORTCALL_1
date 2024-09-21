class Order < ApplicationRecord
  has_ancestry
  belongs_to :service
  belongs_to :invoice
  has_many :order_variables, -> { order(position: :asc) }, dependent: :destroy
  after_create :create_order_variables
  validates :name, presence: true
  has_and_belongs_to_many :taxes



  def create_order_variables
    service.variables.sort_by(&:position).each do |v|
      OrderVariable.create(order: self, name: v.name,
                             operator: v.operator,
                             fixed: v.fixed,
                             value: v.value,
                             role: v.role)
    end
  end

  def update_family_values
    
  end

  def calculate
    begin
      result = $calculator.evaluate!(formula)
    rescue Dentaku::UnboundVariableError => e
      result = "Variable non liée - #{e.message}"
    rescue Dentaku::ParseError => e
      result = "Erreur de syntaxe - #{e.message}"
    rescue StandardError => e
      result = "Erreur: #{e.message}"
    end
    result
  end



  def formula
    if order_variables != []
      order_variables.sort_by(&:position).map do |v|
        "#{v.value}"
      end.join(" ")  
    else
      self.children.map(&:calculate).join('+')
    end
  end

  def budget_price
    if !self.has_children?
      (self.calculate * ( 1 + self.taxes.where(isfee:true).sum(&:percentage)*0.01)).round(4)
    else
      self.children.sum(&:budget_price)
    end
  end

  def invoice_price
    if !self.has_children?
    ((self.calculate * ( 1 + self.taxes.where(isfee:true).sum(&:percentage)*0.01)).round(4)* ( 1 + self.taxes.where(isfee:false).sum(&:percentage)*0.01)).round(4) 
    else
      self.children.sum(&:invoice_price)
    end
  end

end


