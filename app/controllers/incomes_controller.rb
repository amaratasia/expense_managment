class IncomesController < ApplicationController
  before_action :set_income, only: [:show, :edit, :update, :destroy]

  def index
    @expenditures = current_user.incomes.includes(:category)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = WickedPdf.new.pdf_from_string(IncomesController.new.render_to_string(:action => "/report", :layout => false, locals: {income_data: @incomes }))
        send_data(pdf, :filename => "income_report.pdf")
      end
      format.csv do
        send_data(@incomes.as_json, :filename => "income_report.csv")
      end
    end    
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        pdf = WickedPdf.new.pdf_from_string(IncomesController.new.render_to_string(:action => "/report", :page_height => '5in', :page_width => '7in', :layout => false, locals: {income: @income, notice: ''}))
        send_data(pdf, :filename => "invoice.pdf", :disposition => 'attachment')
      end
    end
  end

  def new
    @income = Income.new
  end

  def edit
  end

  def create
    @income = Income.new(income_params)

    respond_to do |format|
      if @income.save
        format.html { redirect_to @income, notice: 'Income was successfully created.' }
        format.json { render :show, status: :created, location: @income }
      else
        format.html { render :new }
        format.json { render json: @income.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @income.update(income_params)
        format.html { redirect_to @income, notice: 'Income was successfully updated.' }
        format.json { render :show, status: :ok, location: @income }
      else
        format.html { render :edit }
        format.json { render json: @income.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @income.destroy
    respond_to do |format|
      format.html { redirect_to incomes_url, notice: 'Income was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_income
      @income = Income.find_by(:id=>params[:id], :user_id => current_user.id)
      raise ActiveRecord::RecordNotFound if @income.blank?
    end

    def income_params
      params[:income][:user_id] = current_user.id
      params.require(:income).permit(:amount,:user_id,:category_attributes => [:name])
    end
end
