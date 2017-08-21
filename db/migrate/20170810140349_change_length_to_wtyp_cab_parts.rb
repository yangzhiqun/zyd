class ChangeLengthToWtypCabParts < ActiveRecord::Migration
  def change
   #change_column :wtyp_czb_parts,:fxpj_1,:string,limit: 30
   #change_column :wtyp_czb_parts,:fxpj_2,:string,limit: 30
   change_column :wtyp_czb_parts,:xzcfqk_1,:text,limit: 30
   change_column :wtyp_czb_parts,:xzcfqk_2,:text,limit: 50
   change_column :wtyp_czb_parts,:xzcfqk_3,:text,limit: 50
   change_column :wtyp_czb_parts,:xzcfqk_4,:text,limit: 50
   change_column :wtyp_czb_parts,:xzcfqk_5,:text,limit: 50
   change_column :wtyp_czb_parts,:xzcfqk_7,:text,limit: 50
   change_column :wtyp_czb_parts,:xzcfqk_9,:text,limit: 50
   change_column :wtyp_czb_parts,:xzcfqk_10,:text,limit: 50
   change_column :wtyp_czb_parts,:xzcfqk_11,:text,limit: 50
   change_column :wtyp_czb_parts,:xzcfqk_12,:text,limit: 50
   change_column :wtyp_czb_parts,:xzcfqk_13,:text,limit: 50
   change_column :wtyp_czb_parts,:xzcfqk_14,:text,limit: 50
   change_column :wtyp_czb_parts,:xzcfqk_15,:text,limit: 50
   change_column :wtyp_czb_parts,:xzcfqk_16,:text,limit: 50
   change_column :wtyp_czb_parts,:xzcfqk_17,:text,limit: 50
   change_column :wtyp_czb_parts,:xzcfqk_18,:text,limit: 50
   change_column :wtyp_czb_parts,:xzcfqk_19,:text,limit: 50
   change_column :wtyp_czb_parts,:xzcfqk_20,:text,limit: 50 
            
   change_column :wtyp_czb_parts,:cpkzqk_1,:string,limit: 100
   change_column :wtyp_czb_parts,:cpkzqk_2,:string,limit: 100
   #change_column :wtyp_czb_parts,:cpkzqk_3,:string,limit: 100
   #change_column :wtyp_czb_parts,:cpkzqk_4,:string,limit: 200
   #change_column :wtyp_czb_parts,:cpkzqk_5,:string,limit: 100
   #change_column :wtyp_czb_parts,:cpkzqk_6,:string,limit: 100
   #change_column :wtyp_czb_parts,:cpkzqk_7,:string,limit: 100
   #change_column :wtyp_czb_parts,:cpkzqk_8,:string,limit: 100
   #change_column :wtyp_czb_parts,:cpkzqk_9,:string,limit: 100
   #change_column :wtyp_czb_parts,:cpkzqk_10,:string,limit: 100
   change_column :wtyp_czb_parts,:cpkzqk_3,:string,limit: 100
  end
end
