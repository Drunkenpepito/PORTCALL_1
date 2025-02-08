class PoLinesController < ApplicationController
  before_action :set_po_line, only: [:show, :edit, :update, :destroy]
  before_action :set_purchase_order

# INDEX
      def index
        @po_lines = @purchase_order.po_lines
      end

# SHOW
      def show
      end

# NEW
      def new
        @po_line = @purchase_order.po_lines.build
      end

# EDIT
      def edit
        @purchase_order = @po_line.purchase_order 
      end

# CREATE
      def create
        @po_line = @purchase_order.po_lines.build(po_line_params)
        if @po_line.save
          @po_lines = @purchase_order.po_lines
          respond_to do |format|
            format.html { redirect_to purchase_order_path(@purchase_order), notice: "PO Line was successfully created." }
            format.turbo_stream    
          end
        else
          render :new
        end
      end
    

# UPDATE
      def update
        if @po_line.update(po_line_params)
          redirect_to purchase_order_path(@po_line.purchase_order), notice: 'PO line was successfully updated.'
              # render turbo_stream: turbo_stream.replace("edit_po_line_#{@po_line.id}", partial: "po_lines/form", locals: { po_line: @po_line })

        else
          render :edit
        end
      end

  # DELETE /purchase_orders/:purchase_order_id/po_lines/:id
  def destroy
    @po_line.destroy!
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to edit_budget_purchase_order_path(@purchase_order), notice: 'PO line was successfully destroyed.' }
    end
  end



  private

  # Use callbacks to share common setup or constraints between actions.
  def set_po_line
    @po_line = PoLine.find(params[:id])
  end

  def set_purchase_order
    if @po_line != nil && @po_line.purchase_order != nil 
      @purchase_order = @po_line.purchase_order 
    else
    @purchase_order = PurchaseOrder.find(params[:purchase_order_id])
    end
  end

  # Only allow a list of trusted parameters through.
  def po_line_params
    params.require(:po_line).permit(:name, :description, :value, :purchase_order_id)
  end
end
