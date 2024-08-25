class OrderVariable < ApplicationRecord
  belongs_to :order
  acts_as_list scope: :order
  
end
