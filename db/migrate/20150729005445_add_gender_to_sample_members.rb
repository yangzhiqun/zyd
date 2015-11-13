class AddGenderToSampleMembers < ActiveRecord::Migration
  def change
		add_column :sample_members, :gender, :string, :limit => 5
  end
end
