class AddContractIdToServices < ActiveRecord::Migration[7.1]
  def change
    add_reference :services, :contract, foreign_key: true
  end
end


