class CreateCategoryMappings < ActiveRecord::Migration[5.0]
  def change
    create_table :category_mappings do |t|
    	t.belongs_to :category, index: true
    	t.integer :categorizable_id
    	t.string :categorizable_type
    end
    add_index :category_mappings, [:categorizable_id, :categorizable_type], :name => 'categorizable_idx'
  end
end
