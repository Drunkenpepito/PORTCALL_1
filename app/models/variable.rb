class Variable < ApplicationRecord
  belongs_to :service
  acts_as_list scope: :service 

  after_create :service_update_gross_and_net
  after_update :service_update_gross_and_net
  after_destroy :service_update_gross_and_net

  validates :value, format: { with: /\A[^,]*\z/, message: "Please replace  ',' with '.' 🙏 " }

  private

  def service_update_gross_and_net
    service.update_gross_and_net
    service.ancestors.each(&:update_gross_and_net)
  end

  # def update_contract_budget_price_and_contract_invoice_price
  #   return unless service.contract.present?
  #   service.contract.calculate_contract_budget_price
  #   service.contract.calculate_contract_invoice_price
  # end
  
end
