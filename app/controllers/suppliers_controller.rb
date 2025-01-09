class SuppliersController < ApplicationController

  def index
    # Supplier.includes(:rich_text_description).all.order(:name)
    @q = Supplier.ransack(params[:q])
    @suppliers = @q.result(distinct: true)
  end
  def update_list
      # Fetch the suppliers list
    Supplier.dl_and_update_suppliers_list
      # If Start again if next page is true
      redirect_to suppliers_path, notice: "Supplier List Updated"
  end
end
