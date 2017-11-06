class LogManagementController < ApplicationController

  TypeNum = {"1"=>"User","2"=>"JgBsb"}
  
  def index
    #36210104
    #where(created_at: DateTime.parse("2016-09-15")..DateTime.parse("2017-09-15").end_of_day)
    @logs = nil
  end

  def search
    begin_time = DateTime.parse(params[:begin_time])
    ending_time = DateTime.parse(params[:ending_time]).end_of_day
    case params["type"]
      when "1"
        obj = User.find_by_uid(params["uid"])
      when "2"
        obj = JgBsb.find(params["jg_id"])
    end
    @logs = obj.nil? ? obj : Audited::Audit.where(auditable_id:obj.id, auditable_type: TypeNum[params["type"]], created_at: begin_time..ending_time).order('created_at desc').paginate(:page => params[:page], :per_page => 5)
    render :partial => "index_show_list", :locals => {:logs => @logs}
  end
end
