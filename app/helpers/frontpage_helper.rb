module FrontpageHelper

	def bank_statments(user_id)
		income_data = Income.joins(:category).where(:user_id=>user_id).select("incomes.*, categories.name as category_name").as_json
		income_data.map{|x| x["type"] = "CREDIT"}
		expenditure_data = Expenditure.joins(:category).where(:user_id=>user_id).select("expenditures.*, categories.name as category_name").as_json
		expenditure_data.map{|x| x["type"] = "DEDIT"}
		return (income_data + expenditure_data).sort_by{|x| x['created_at']}
	end
end
