class FrontpageController < ApplicationController
	include FrontpageHelper

	def bank_statment(params=nil)
		complete_data = bank_statments(current_user.id)
		respond_to do |format|
			format.pdf do 
				puts complete_data
				pdf = WickedPdf.new.pdf_from_string(FrontpageController.new.render_to_string(:action => "/report", :layout => false, locals: {complete_data: complete_data }))
        send_data(pdf, :filename => "bank_statment.pdf")
			end
	      format.csv do
	        send_data(complete_data, :filename => "bank_statment.csv")
	      end
    	end   		
	end
end
