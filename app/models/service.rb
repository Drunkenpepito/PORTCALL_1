class Service < ApplicationRecord
    validates :name, presence: true
    belongs_to :contract
    has_ancestry
    has_many :variables , -> { order(position: :asc) }, dependent: :destroy

end
