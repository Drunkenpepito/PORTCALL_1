class FormulasController < ApplicationController
    def new
        @service = Service.find(params[:service_id])
        @formula = Formula.new
    end

    def create
        @formula = Formula.new(formula_params)
        @service = Service.find(params[:service_id])
        @formula.service = @service

        if @formula.save
            redirect_to service_path(@service), notice: "Formula was successfully created."
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @formula = Formula.find(params[:id])
        @variables = @formula.variables
    end

    def formula_params
        params.require(:formula).permit(:name)
    end
end
