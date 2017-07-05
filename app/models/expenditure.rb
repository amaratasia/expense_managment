class Expenditure < ApplicationRecord
	has_one :category_mapping, as: :categorizable
	has_one :category, as: :categorizable, through: :category_mapping
	validates :amount, numericality: {greater_than: 0 }, presence: true

	accepts_nested_attributes_for :category

	def category_attributes=(category_attributes)
		self.category = Category.find_or_create_by(:name => category_attributes[:name])
	end
end
