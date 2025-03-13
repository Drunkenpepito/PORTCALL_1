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


  def update_gross_and_net
    calculate_gross
    calculate_net
  end

  def calculate_net
    calculated = calculate
    calculated_net = (calculated.is_a?(Numeric)) ? (calculated * (1 + tax_regimes.where(isfee: true).sum(&:percentage) * 0.01)).round(4) : nil
    unless calculated_net.nil?
      new_net = if !has_children?
                  calculated_net
                else
                  children.sum(&:net)
                end
      update_column(:net, new_net)
    end
  end

  def calculate_gross
    calculated = calculate
    calculated_gross = (calculated.is_a?(Numeric)) ? ((calculated * (1 + tax_regimes.where(isfee: true).sum(&:percentage) * 0.01)).round(4) * (1 + tax_regimes.where(isfee: false).sum(&:percentage) * 0.01)).round(4) : nil
    unless calculated_gross.nil?
      new_gross = if !has_children?
                    calculated_gross
                   else
                    children.sum(&:gross)
                   end
      update_column(:gross, new_gross)
    end
  end

  def update_gross
    calculated = calculate
    calculated_gross = (calculated.is_a?(Numeric)) ? ((calculated * (1 + tax_regimes.where(isfee: true).sum(&:percentage) * 0.01)).round(4) * (1 + tax_regimes.where(isfee: false).sum(&:percentage) * 0.01)).round(4) : nil
    unless calculated_gross.nil?
      # update_column(:gross, calculated_gross)
      update(gross: calculated_gross)
    end
  end

  def update_net
    calculated = calculate
    calculated_net = (calculated.is_a?(Numeric)) ? (calculated * (1 + tax_regimes.where(isfee: true).sum(&:percentage) * 0.01)).round(4) : nil
    unless calculated_net.nil?
      # update_column(:net, calculated_net)
    update(net: calculated_net)
    end
  end

end

  
  # def total_if_no_fomula
  #   self.descendants.reverse.each { |s| s.has_children? && s.formula == "" && s.children.map(&:calculate).all?{ |c| c != nil}? s.value = s.children.sum(&:calculate) && s.save : s.value = 0  }
  # end

 
