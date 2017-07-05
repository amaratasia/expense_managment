class Category < ApplicationRecord
	has_many :category_mappings
	has_many :incomes, through: :category_mappings, source: :categorizable, :source_type => 'Income'
	has_many :expenditures, through: :category_mappings, source: :categorizable, :source_type => 'Expenditure'
	
	validates :name, presence: true
 	validates :name, :uniqueness => { "case_sensitive" => false }
end
