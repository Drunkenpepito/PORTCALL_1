class SuppliersController < ApplicationController

  def update_suppliers_list
      # Fetch the suppliers list
    Supplier.get_and_update_suppliers_list
      # If Start again if next page is true
  end
end
