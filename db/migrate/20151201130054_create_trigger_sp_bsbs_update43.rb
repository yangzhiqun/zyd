# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggerSpBsbsUpdate43 < ActiveRecord::Migration
  def up
    drop_trigger("sp_bsbs_after_update_of_updated_at_row_tr", "sp_bsbs", :generated => true)

    create_trigger("sp_bsbs_after_update_of_updated_at_sp_i_state_row_tr", :generated => true, :compatibility => 1).
        on("sp_bsbs").
        after(:update).
        of(:updated_at, :sp_i_state) do
      "UPDATE tmp_sp_bsbs SET sp_i_state=NEW.sp_i_state, sp_s_16=NEW.sp_s_16, sp_s_3=NEW.sp_s_3, sp_s_202=NEW.sp_s_202, sp_s_14=NEW.sp_s_14, sp_s_43=NEW.sp_s_43, sp_s_2_1=NEW.sp_s_2_1, sp_s_35=NEW.sp_s_35, sp_s_64=NEW.sp_s_64, sp_s_1=NEW.sp_s_1, sp_s_17=NEW.sp_s_17, sp_s_20=NEW.sp_s_20, sp_s_85=NEW.sp_s_85, created_at=NEW.created_at, updated_at=NEW.updated_at, sp_s_214=NEW.sp_s_214, sp_s_71=NEW.sp_s_71, fail_report_path=NEW.fail_report_path, tname=NEW.tname, sp_s_18=NEW.sp_s_18, sp_s_70=NEW.sp_s_70 where id=NEW.id;"
    end
  end

  def down
    drop_trigger("sp_bsbs_after_update_of_updated_at_sp_i_state_row_tr", "sp_bsbs", :generated => true)

    create_trigger("sp_bsbs_after_update_of_updated_at_row_tr", :generated => true, :compatibility => 1).
        on("sp_bsbs").
        after(:update).
        of(:updated_at) do
      "UPDATE tmp_sp_bsbs SET sp_i_state=NEW.sp_i_state, sp_s_16=NEW.sp_s_16, sp_s_3=NEW.sp_s_3, sp_s_202=NEW.sp_s_202, sp_s_14=NEW.sp_s_14, sp_s_43=NEW.sp_s_43, sp_s_2_1=NEW.sp_s_2_1, sp_s_35=NEW.sp_s_35, sp_s_64=NEW.sp_s_64, sp_s_1=NEW.sp_s_1, sp_s_17=NEW.sp_s_17, sp_s_20=NEW.sp_s_20, sp_s_85=NEW.sp_s_85, created_at=NEW.created_at, updated_at=NEW.updated_at, sp_s_214=NEW.sp_s_214, sp_s_71=NEW.sp_s_71, fail_report_path=NEW.fail_report_path, tname=NEW.tname, sp_s_18=NEW.sp_s_18, sp_s_70=NEW.sp_s_70 where id=NEW.id;"
    end
  end
end
