class Formula < ApplicationRecord
  #  Model Formula has been created initially but we have been using act_as_list instead to link Service and Variable models then
  belongs_to :service
  has_many :variables
end
