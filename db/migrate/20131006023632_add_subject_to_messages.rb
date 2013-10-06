class AddSubjectToMessages < ActiveRecord::Migration
  def up
	  add_column :messages, :subject, :string
  end
  
  def down
	  remove_column :messages, :subject
  end
  
end
