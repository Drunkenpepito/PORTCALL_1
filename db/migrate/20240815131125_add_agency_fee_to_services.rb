class AddAgencyFeeToServices < ActiveRecord::Migration[7.1]
  def change
    add_column :services, :agency_fee, :boolean
  end
end
