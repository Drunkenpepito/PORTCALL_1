class Variable < ApplicationRecord
  belongs_to :service
  acts_as_list scope: :service 

  after_update_commit :service_update_gross_and_net

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
