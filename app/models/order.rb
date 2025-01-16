class Order < ApplicationRecord
  has_ancestry
  belongs_to :service
  belongs_to :invoice
  has_many :order_variables, -> { order(position: :asc) }, dependent: :destroy
  after_create :create_order_variables
  # after_create :create_taxes
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



  def create_taxes
    service.tax_regimes.each do |tax|
      Tax.create(order: self, name: tax.name,
                             percentage: tax.percentage,
                             isfee: tax.isfee
                             )
    end
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
      # cette fromule est a changer car le calculate des children est 
      #basé sur l'ancienne formula. Il faut relancer les calculate sur chaque ordre du path dans le sens enfant --> parent
      #pour avoir le bon calculate  
    end
  end

  def budget_price
    if !self.has_children? 
        (self.calculate * ( 1 + self.taxes.where(isfee:true).sum(&:percentage)*0.01)).round(4) if self.calculate.is_a? Numeric
    else
      # POSSIBLE QU'IL Y AIT UN PB ICI SI UN DES ORDER.PRICE N'EST PAS UN NUMERIC
      if self.children.all?{|o| o.budget_price.is_a? Numeric } 
        self.children.sum(&:budget_price)
      end
    end
  end

  def invoice_price
    if !self.has_children?
        ((self.calculate * ( 1 + self.taxes.where(isfee:true).sum(&:percentage)*0.01)).round(4)* ( 1 + self.taxes.where(isfee:false).sum(&:percentage)*0.01)).round(4) if self.calculate.is_a? Numeric
    else
      # POSSIBLE QU'IL Y AIT UN PB ICI SI UN DES ORDER.PRICE N'EST PAS UN NUMERIC
      if self.children.all?{|o| o.invoice_price.is_a? Numeric } 
        self.children.sum(&:invoice_price)
      end
    end
  end

end


