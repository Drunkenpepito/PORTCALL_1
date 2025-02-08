class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  before_action :set_purchase_order, only: [:new, :create, :index]

  # GET /purchase_orders/:purchase_order_id/payments
  def index
    @payments = @purchase_order.payments
  end

  # GET /payments/:id
  def show
  end

  # GET /purchase_orders/:purchase_order_id/payments/new
  def new
    @payment = @purchase_order.payments.build
  end

  # POST /purchase_orders/:purchase_order_id/payments
  def create
    @payment = @purchase_order.payments.build(payment_params)
    if @payment.save!
      respond_to do |format|
        format.html { redirect_to purchase_order_path(@purchase_order), notice: "Scheduled Payment was successfully created." }
        format.turbo_stream    
      end
    else
      render :new
    end
  end

  # GET /payments/:id/edit
  def edit
  end

  # PATCH/PUT /payments/:id
  def update
    if @payment.update(payment_params)
      redirect_to purchase_order_path(@payment.purchase_order), notice: "Payment was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /payments/:id
  def destroy
    @payment.destroy
    redirect_to purchase_order_path(@payment.purchase_order), notice: "Payment was successfully deleted."
  end

  private

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def set_purchase_order
    @purchase_order = PurchaseOrder.find(params[:purchase_order_id])
  end

 
   

  def payment_params
    params.require(:payment).permit(:value, :date, :purchase_order_id)  # modifiez les attributs selon votre modèle
  end
end
