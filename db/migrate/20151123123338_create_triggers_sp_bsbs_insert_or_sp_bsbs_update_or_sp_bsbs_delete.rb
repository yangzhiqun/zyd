# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersSpBsbsInsertOrSpBsbsUpdateOrSpBsbsDelete < ActiveRecord::Migration
  def up
    create_trigger("sp_bsbs_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("sp_bsbs").
        after(:insert) do
      "INSERT INTO tmp_sp_bsbs(id, sp_i_state, sp_s_16, sp_s_3, sp_s_202, sp_s_14, sp_s_43, sp_s_2_1, sp_s_35, sp_s_64, sp_s_1, sp_s_17, sp_s_20, sp_s_85, created_at, updated_at) values(NEW.id, NEW.sp_i_state, NEW.sp_s_16, NEW.sp_s_3, NEW.sp_s_202, NEW.sp_s_14, NEW.sp_s_43, NEW.sp_s_2_1, NEW.sp_s_35, NEW.sp_s_64, NEW.sp_s_1, NEW.sp_s_17, NEW.sp_s_20, NEW.sp_s_85, NEW.created_at, NEW.updated_at);"
    end

    create_trigger("sp_bsbs_after_update_of_sp_i_state_sp_s_16_sp_s_3_sp_s_202_s_tr", :generated => true, :compatibility => 1).
        on("sp_bsbs").
        after(:update).
        of(:sp_i_state, :sp_s_16, :sp_s_3, :sp_s_202, :sp_s_14, :sp_s_43, :sp_s_2_1, :sp_s_35, :sp_s_64, :sp_s_1, :sp_s_17, :sp_s_20, :sp_s_85) do
      "UPDATE tmp_sp_bsbs SET sp_i_state=NEW.sp_i_state, sp_s_16=NEW.sp_s_16, sp_s_3=NEW.sp_s_3, sp_s_202=NEW.sp_s_202, sp_s_14=NEW.sp_s_14, sp_s_43=NEW.sp_s_43, sp_s_2_1=NEW.sp_s_2_1, sp_s_35=NEW.sp_s_35, sp_s_64=NEW.sp_s_64, sp_s_1=NEW.sp_s_1, sp_s_17=NEW.sp_s_17, sp_s_20=NEW.sp_s_20, sp_s_85=NEW.sp_s_85, created_at=NEW.created_at, updated_at=NEW.updated_at where id=NEW.id;"
    end

    create_trigger("sp_bsbs_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("sp_bsbs").
        after(:delete) do
      "DELETE FROM tmp_sp_bsbs where id=OLD.id;"
    end
  end

  def down
    drop_trigger("sp_bsbs_after_insert_row_tr", "sp_bsbs", :generated => true)

    drop_trigger("sp_bsbs_after_update_of_sp_i_state_sp_s_16_sp_s_3_sp_s_202_s_tr", "sp_bsbs", :generated => true)

    drop_trigger("sp_bsbs_after_delete_row_tr", "sp_bsbs", :generated => true)
  end
end
