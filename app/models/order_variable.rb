class OrderVariable < ApplicationRecord
  belongs_to :order
  acts_as_list scope: :order
  
  # after_update_commit :order_update_gross_and_net

  private

  def order_update_gross_and_net
    order.update_gross_and_net
    order.ancestors.each(&:update_gross_and_net)
  end
end
