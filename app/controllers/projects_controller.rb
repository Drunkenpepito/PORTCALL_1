
  class ProjectsController < ApplicationController
    before_action :set_project, only: %i[ show edit update destroy ] 
    before_action :authenticate_user!
   
    def index
      @projects = current_user.projects
      @q = Project.ransack(params[:q])
      @projects = @q.result(distinct: true)
      
      # @tasks_count = 0
      # @projects.each do |p|
      #   @tasks_count += p.tasks.where(completed:false).count 
      #   @tasks_count += p.tasks.where(completed:nil).count 
      # end
      # @projects = Project.all
    end

  
    # def archived_projects
    #   @projects = current_user.projects.where(archived:true)
    # end
  
    def show
      @project = Project.find(params[:id])
      @task = Task.new
      @task.project = @project
      @sections = @project.tasks.where(section:true)
      @tab = @sections.map(&:position)
    end

    
    def new
      @project = current_user.projects.build 
      @categories = Project.all.map(&:category).uniq
      @suppliers = Supplier.all
    end
  
    def edit
      @categories = Project.all.map(&:category).uniq
      @categories.to_a << "ALL"  
      @categories.to_a << "OTHER"
      @suppliers= Supplier.all
      @project = Project.find(params[:id])
      @non_completed_tasks = @project.tasks.where( completed: false) + @project.tasks.where( completed: nil) 
    end

    
    def create
      @project = current_user.projects.build(project_params)
      @project.photo =  params[:project][:photo]
      if @project.category = nil || ""
        @project.category = "OTHER"
      end
      @project.archived = false

      respond_to do |format|
        if @project.save
          format.html { redirect_to project_url(@project), notice: "Project was successfully created." }
          format.json { render :show, status: :created, location: @project }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
      if @project.category ="RFQ"
        @project.tender = Tender.create(name:@project.name)
      end
    end
  
    def update
      if @project.category = nil || @project.category = ""
        @project.category = "OTHER"
      else 
        @project.category = params[:project][:category]
      end
      @project.supplier_id = params[:project][:supplier_id]
     respond_to do |format|
        if @project.update(project_params)
          format.html { redirect_to project_url(@project), notice: "Project was successfully updated." }
          format.json { render :show, status: :ok, location: @project }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def destroy
      @project.destroy
  
      respond_to do |format|
        format.html { redirect_to projects_url, notice: "Project was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  
    def sourcing
      @categories = Project.all.map(&:category).uniq
      @category = params[:category]
      @filter = params[:filter ] if params[:filter] != nil 
      if @filter == 'ALL' 
        @projects = Project.all.where(archived:false)
        @archived_projects= Project.where(archived:true)
      elsif @filter == 'SOURCING PROJECTS' 
        @projects = Project.where(require_sourcing:true , archived:false)
        @archived_projects= Project.where(category:nil, archived:true)
      elsif @filter == 'OTHER' 
        @projects = Project.where(category:nil , archived:false)
        @archived_projects= Project.where(category:nil, archived:true)
      else
        @projects = Project.where(category:@category , archived:false)
        @archived_projects= Project.where(category: @category, archived:true)
      end
      compute_spend

      @q = Project.ransack(params[:q])
      @projs = @q.result(distinct: true)
      @tasks_count = 0
      @projs.each do |p|
        @tasks_count += p.tasks.where(completed:false).count 
        @tasks_count += p.tasks.where(completed:nil).count 
      end
      
    end
    
    def market
      @projects = Project.where(category:'MARKET', archived:false)
    end
    
    def wisdom
    end

    def priorities
      @tasks = Task.all.where(priority:true)
      @projects = @tasks.map{|t| t.project}.uniq
      @categories = @projects.uniq.map(&:category).uniq
      if params[:category]
        @tasks =[]
        @projects = Project.where(category:params[:category])
        @projects.each do |p|
          p.tasks.each do |t|
            @tasks << t if t.priority
          end
        end
      end
    end
    
    def admin
    end

    def store_pictures
      @projects = Project.all
      @projects.each do |p|
        p.photo
      end
    end

    def store
      require "csv"
      
      # Store projects
      @count_projects = 0
      filepath = "app/assets/db_projects.csv"
      CSV.open(filepath, "wb") do |csv|
        Project.all.each do |p|
          if p.description != nil
            csv << ["#{p.name}","#{p.description.gsub("\r\n", '-----')}","#{p.completed}","#{p.archived}","#{p.box_link}","#{p.category}", "#{p.position}","#{p.user_id}","#{p.created_at}","#{p.updated_at}","#{p.NDA_complete}","#{p.supplier_connect_complete}","#{p.payment_terms_complete}","#{p.complyworks_complete}","#{p.contract_complete}","#{p.cost_complete}","#{p.todo}"] 
          else  
            csv << ["#{p.name}","#{p.description}","#{p.completed}","#{p.archived}","#{p.box_link}","#{p.category}","#{p.position}","#{p.user_id}","#{p.created_at}","#{p.updated_at}","#{p.NDA_complete}","#{p.supplier_connect_complete}","#{p.payment_terms_complete}","#{p.complyworks_complete}","#{p.contract_complete}","#{p.cost_complete}","#{p.todo}"] 
          end
          @count_projects += 1
        end
      end


      
      # Store tasks
      @count_tasks = 0
      filepath = "app/assets/db_tasks.csv"
      CSV.open(filepath, "wb") do |csv|
        Task.all.each do |t|
          if t.description != nil
            csv << ["#{t.name}","#{t.description.gsub("\n", '-----')}".gsub(/'\'/,'---'),"#{t.status}","#{t.completed}","#{t.completed_at}","#{t.position}","#{t.project.name}","#{t.created_at}","#{t.updated_at}","#{t.priority}"] 
          else
            csv << ["#{t.name}","#{t.description}".gsub(/'\'/,'---'),"#{t.status}","#{t.completed}","#{t.completed_at}","#{t.position}","#{t.project.name}","#{t.created_at}","#{t.updated_at}","#{t.priority}"] 
          end
          @count_tasks += 1
        end
      end
      
      # Store orders
      @count_orders = 0
      filepath = "app/assets/db_orders.csv"
      CSV.open(filepath, "wb") do |csv|
        Order.all.each do |o|
          csv << ["#{o.name}","#{o.budget}","#{o.project.name}","#{o.created_at}","#{o.updated_at}","#{o.position}"] 
          @count_orders += 1
        end
      end
      
      # Store cost_lines
      @count_cost_lines = 0
      filepath = "app/assets/db_cost_lines.csv"
      CSV.open(filepath, "wb") do |csv|
        CostLine.all.each do |cl|
          csv << ["#{cl.name}","#{cl.description}","#{cl.unit}","#{cl.quantity}","#{cl.price}","#{cl.total}","#{cl.created_at}","#{cl.updated_at}","#{cl.project.name}"] 
          @count_cost_lines += 1
        end
      end

      # Store sourcing status
      @count_todo_projects = 0
      filepath = "app/assets/db_sourcing.csv"
      CSV.open(filepath, "wb") do |csv|
        csv << ["PROJECT", "NDA", "SC" , "PT", "CW", "CONTRACT" , "BUDGET", "PO", "COMMENT"]
        Project.all.each do |p|
          csv << [
            "#{p.name}",
            "#{p.NDA_complete}",
            "#{p.supplier_connect_complete}",
            "#{p.payment_terms_complete}",
            "#{p.complyworks_complete}",
            "#{p.contract_complete}",
            "#{p.cost_complete}",
            p.orders != nil && p.orders.count == 1  ? "#{p.orders.first.name}":"#{p.orders.map(&:name)}",
            "#{p.todo}"
          ] 
          @count_todo_projects += 1
        end
      end

      # Store suppliers
      @count_suppliers = 0
      filepath = "app/assets/db_suppliers.csv"
      CSV.open(filepath, "wb") do |csv|
        csv << ["SUPPLIER", "CONTACT", "NDA", "SC", "CW", "MSA", "ISM", "SERVICE", "REGION", "COMMENT"]
        Supplier.all.each do |s|
          csv << [
            "#{s.name}",
            "#{s.contact}",
            "#{s.nda}",
            "#{s.sc}",
            "#{s.cw}",
            "#{s.msa}",
            "#{s.ism}",
            "#{s.commodity}",
            "#{s.region}",
            "#{s.comment_onboarding}",
          ] 
          @count_suppliers += 1
        end
      end

      # Store invoices
      @count_invoices = 0
      filepath = "app/assets/db_invoices.csv"
      CSV.open(filepath, "wb") do |csv|
        #csv << ["INVOICE", "DATE", "DESCRIPTION", "GR", "ARCHIVED", "TOTAL", "PROJECT"] it prevents db:seed to work correctly 
        Invoice.all.each do |i|
          csv << [
            "#{i.number}",
            "#{i.date}",
            "#{i.description}",
            "#{i.goods_receipt}",
            "#{i.archived}",
            "#{i.total}",
            "#{i.project.name}",
          ] 
          @count_invoices += 1
        end
      end
      
      ProjectMailer.db_backup.deliver_later

    end

    def budget
      @project = Project.find(params[:id])
      @cost_line = CostLine.new
      @cost_line.project= @project
      @cost_lines = @project.cost_lines
      @budget = 0
      @project.cost_lines.each do |cl|
        @budget += cl.total.to_i if cl.total != nil
      end
      @invoices= @project.invoices
      @invoice= Invoice.new
    end

    def sourcing_plan
      @project = Project.find(params[:project_id])
      @sourcing_plan = @project.sourcing_plan
    end

    def wrapup
      @project = Project.find(params[:id])
      @task = Task.new
      @task.project = @project
      @sections = @project.tasks.where(section:true)
      @tab = @sections.map(&:position)
    end 

    private
      def set_project
        #@project = current_user.projects.find(params[:id])
        @project = Project.all.find(params[:id])

      end

      def compute_spend
        #@projects != nil ?  @projects = Project.all.where(category: @category) : @projects = Project.all
        @projects.each do |p|
          p.update!(budget: p.cost_lines.sum{|cl| cl.total!= nil ? cl.total : 0 })
        end
        @spend = @projects.sum do |p|
          p.budget != nil ? p.budget : 0
        end
      end

      
  
      def project_params
        params.require(:project).permit(:name, :description,  :box_link, :category, :commodity, :photo, :filter, :todo, :require_sourcing)
      end
  end
  







