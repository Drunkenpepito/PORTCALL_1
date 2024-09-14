class VariablesController < ApplicationController
    def new
        @variable = Variable.new
    end
    

    def create
        @service = Service.find(params[:service_id])
        @variable = Variable.new(variable_params)
        @variable.service = @service
        @variable.save!
        respond_to do |format|
          format.html { redirect_to service_path(@service) }
          format.turbo_stream
        end

    end

    def edit
        @variable = Variable.find(params[:id])
    end

    def update
        @variable = Variable.find(params[:id])
        if @variable.update(variable_params)
            # @variable.service.calculate_totals
            redirect_to service_path( @variable.service), notice: "Variable was successfully updated."
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @variable = Variable.find(params[:id])
        @service = @variable.service
        @variable.destroy
        respond_to do |format|
            format.html { redirect_to service_path(@variable.service) }
            format.turbo_stream
        end
    end

    def show
        @variable = Variable.find(params[:id])
    end



  def move
    @variable = Variable.find(params[:id])
    @variable.insert_at(params[:position].to_i)
    head :no_content # renvoie le http code 204 server OK et no content to send back
  end


    def variable_params
        params.require(:variable).permit(:name, :value, :operator, :fixed, :position)
    end
    
end
