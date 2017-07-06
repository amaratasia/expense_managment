class ExpendituresController < ApplicationController
  before_action :set_expenditure, only: [:show, :edit, :update, :destroy]

  def index
    @expenditures = current_user.expenditures.includes(:category)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = WickedPdf.new.pdf_from_string(ExpendituresController.new.render_to_string(:action => "/report", :page_height => '5in', :page_width => '7in', :layout => false, locals: {expenditure_data: @expenditures }))
        send_data(pdf, :filename => "expenditure_report.pdf", :disposition => 'attachment')
      end
      format.csv do
        send_data(@expenditures.as_json, :filename => "expenditure_report.csv")
      end
    end
  end

  def show
  end

  def new
    @expenditure = Expenditure.new
  end

  def edit
  end

  def create
    @expenditure = Expenditure.new(expenditure_params)

    respond_to do |format|
      if @expenditure.save
        format.html { redirect_to @expenditure, notice: 'Expenditure was successfully created.' }
        format.json { render :show, status: :created, location: @expenditure }
      else
        format.html { render :new }
        format.json { render json: @expenditure.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @expenditure.update(expenditure_params)
        format.html { redirect_to @expenditure, notice: 'Expenditure was successfully updated.' }
        format.json { render :show, status: :ok, location: @expenditure }
      else
        format.html { render :edit }
        format.json { render json: @expenditure.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @expenditure.destroy
    respond_to do |format|
      format.html { redirect_to expenditures_url, notice: 'Expenditure was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_expenditure
      @expenditure = Expenditure.find_by(:id => params[:id], :user_id => current_user.id)
      raise ActiveRecord::RecordNotFound if @expenditure.blank?
    end

    def expenditure_params
      params[:expenditure][:user_id] = current_user.id
      params.require(:expenditure).permit(:amount,:user_id,:category_attributes => [:name])
    end
end
