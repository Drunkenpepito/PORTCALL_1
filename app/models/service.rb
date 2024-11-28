class Service < ApplicationRecord
    validates :name, presence: true
    belongs_to :contract
    has_ancestry 
    has_many :variables , -> { order(position: :asc) }, dependent: :destroy
    validates :name, presence: true
    has_many :orders
    has_and_belongs_to_many :tax_regimes
    # acts_as_list scope: :contract 




  def calculate
 
      begin
        result = $calculator.evaluate!(formula)
      rescue Dentaku::UnboundVariableError => e
        # Gérer l'erreur de variable non liée
        result = "Variable not linked - #{e.message}"
        # ou une valeur par défaut
      rescue Dentaku::ParseError => e
        # Gérer l'erreur de syntaxe
        result = "Syntax error - #{e.message}"
        # ou une valeur par défaut
      rescue StandardError => e
        # Gérer toute autre erreur
        result = "Error: #{e.message}"
        # ou une valeur par défaut
      end
      # Utilisez le résultat
   
    result
  end

  def formula
    if variables != []
    # renvoit un string avec la formule du service
      variables.sort_by(&:position).map do |v|
        "#{v.value}"
      end.join(" ")  
    else
      self.children.map(&:calculate).join('+')
    end
  end

  def budget_price
    if !self.has_children? && self.calculate != nil
      (self.calculate * ( 1 + self.tax_regimes.where(isfee:true).sum(&:percentage)*0.01)).round(4)
    else
      self.children.sum(&:budget_price)
    end
  end

  def invoice_price
    if !self.has_children?  && self.calculate != nil
    ((self.calculate * ( 1 + self.tax_regimes.where(isfee:true).sum(&:percentage)*0.01)).round(4)* ( 1 + self.tax_regimes.where(isfee:false).sum(&:percentage)*0.01)).round(4) 
    else
      self.children.sum(&:invoice_price)
    end
  end

  # def total_if_no_fomula
  #   self.descendants.reverse.each { |s| s.has_children? && s.formula == "" && s.children.map(&:calculate).all?{ |c| c != nil}? s.value = s.children.sum(&:calculate) && s.save : s.value = 0  }
  # end

 
end
