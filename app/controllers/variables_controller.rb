class VariablesController < ApplicationController
    def new
        @formula = Formula.find(params[:formula_id])
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
            redirect_to edit_formula_path( @variable.formula), notice: "Variable was successfully updated."
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @variable = Variable.find(params[:id])
        @variable.destroy
        respond_to do |format|
            format.html { redirect_to service_path(@variable.service) }
            format.turbo_stream
        end
    end

    def show
        @variable = Variable.find(params[:id])
    end

    def variable_params
        params.require(:variable).permit(:name, :value, :operator, :fixed, :position)
    end
    
end
