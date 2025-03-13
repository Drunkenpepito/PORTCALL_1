class Order < ApplicationRecord
  has_ancestry
  belongs_to :service
  belongs_to :invoice
  has_many :order_variables, -> { order(position: :asc) }, dependent: :destroy
  validates :name, presence: true
  has_and_belongs_to_many :taxes
  
  after_create :create_order_variables


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
  
  def update_gross_and_net
    calculate_gross
    calculate_net
  end

  def calculate_net
    calculated = calculate
    calculated_net = (calculated.is_a?(Numeric)) ? (calculated * (1 + taxes.where(isfee: true).sum(&:percentage) * 0.01)).round(4) : nil
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
    calculated_gross = (calculated.is_a?(Numeric)) ? ((calculated * (1 + taxes.where(isfee: true).sum(&:percentage) * 0.01)).round(4) * (1 + taxes.where(isfee: false).sum(&:percentage) * 0.01)).round(4) : nil
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
    calculated_gross = (calculated.is_a?(Numeric)) ? ((calculated * (1 + taxes.where(isfee: true).sum(&:percentage) * 0.01)).round(4) * (1 + taxes.where(isfee: false).sum(&:percentage) * 0.01)).round(4) : nil
    unless calculated_gross.nil?
      update(gross: calculated_gross)
    end
  end

  def update_net
    calculated = calculate
    calculated_net = (calculated.is_a?(Numeric)) ? (calculated * (1 + taxes.where(isfee: true).sum(&:percentage) * 0.01)).round(4) : nil
    unless calculated_net.nil?
    update(net: calculated_net)
    end
  end

  
  
  private




end


