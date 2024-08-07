class AddSericeIdToVariables < ActiveRecord::Migration[7.1]
  def change
    add_reference :variables, :service, foreign_key: true
  end
end
