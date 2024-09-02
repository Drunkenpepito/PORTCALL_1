class Service < ApplicationRecord
    validates :name, presence: true
    belongs_to :contract
    has_ancestry 
    has_many :variables , -> { order(position: :asc) }, dependent: :destroy
    validates :name, presence: true
    has_many :orders

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
    # renvoit un string avec la formule de l'service
    variables.sort_by(&:position).map do |v|
      "#{v.value}"
    end.join(" ")
  end
end
