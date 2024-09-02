class Order < ApplicationRecord
  has_ancestry
  belongs_to :service
  belongs_to :invoice
  has_many :order_variables, -> { order(position: :asc) }, dependent: :destroy
  after_create :create_order_variables
  validates :name, presence: true


  def create_order_variables
    service.variables.sort_by(&:position).each do |v|
      OrderVariable.create(order: self, name: v.name,
                             operator: v.operator,
                             fixed: v.fixed,
                             value: v.value,
                             role: v.role)
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
    order_variables.sort_by(&:position).map do |v|
      "#{v.value}"
    end.join(" ")
  end
end


