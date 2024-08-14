class Variable < ApplicationRecord
  belongs_to :service
  acts_as_list scope: :service 
end
