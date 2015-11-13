class PublicationWorker
	include Sidekiq::Worker

	def perform(pub_id, params, user_id)
    params.symbolize_keys!

    current_user = User.find(user_id)
    unless params[:baosong_a].blank?
      @baosong_bs = BaosongB.where(baosong_a_id: BaosongA.find_by_name(params[:baosong_a]).id)
    else
      @baosong_bs = []
    end

    if params[:begin_at].blank?
      @begin_at = Time.now.to_datetime.beginning_of_day
    else
      @begin_at = DateTime.parse(params[:begin_at]).beginning_of_day
    end

    if params[:end_at].blank?
      @end_at = Time.now.to_datetime.end_of_day
    else
      @end_at = DateTime.parse(params[:end_at]).end_of_day
    end

    @sp_data = Spdatum.joins("LEFT JOIN pub_spdata AS sp ON sp.spdata_id=spdata.id LEFT JOIN sp_bsbs AS s ON s.id=spdata.sp_bsb_id").where('sp.id IS NULL AND s.updated_at BETWEEN ? AND ?', @begin_at, @end_at).where("s.sp_i_state = 9")

    # 不合格项
    if params[:current_tab].to_i == 0
      @sp_data = @sp_data.where("s.sp_s_71 LIKE '%不合格%' OR s.sp_s_71 LIKE '%问题%'").where("spdata.spdata_2 LIKE '%不合格%' OR spdata.spdata_2 LIKE '%问题%'")
    end

    if !params[:baosong_a].blank? and !params[:baosong_a].eql?("请选择")
      @sp_data = @sp_data.where("s.sp_s_70 = ?", params[:baosong_a])
    end

    if !params[:baosong_b].blank? and !params[:baosong_b].eql?("请选择")
      @sp_data = @sp_data.where("s.sp_s_67 = ?", params[:baosong_b])
    end

    @sp_data = @sp_data.select("s.id as sp_bsb_id, spdata.id, s.sp_s_64, s.sp_s_65, s.sp_s_1, s.sp_s_7, s.sp_s_14, s.sp_s_16, s.sp_s_26, s.sp_s_74, s.sp_d_28, spdata.spdata_0, spdata.spdata_1, spdata.spdata_15")
    @sp_data = @sp_data.paginate(:page => params[:page], :per_page => 10)

    if params[:uncheck_all].to_i == 0 and !params[:ids].blank?
      @sp_data = @sp_data.where('spdata.id NOT IN (?)', params[:ids])
    elsif params[:uncheck_all].to_i == 1 and !params[:ids].blank?
      @sp_data = @sp_data.where('spdata.id IN (?)', params[:ids])
    end

    ActiveRecord::Base.transaction do
      @sp_data.find_each do |bsb|
        @sp_bsb = SpBsb.find(bsb.sp_bsb_id)
        @pub_sp_bsb = PubSpBsb.where(sp_bsb_id: @sp_bsb.id, title: @table_name_parts.join('/'), user_id: current_user.id, username: current_user.tname, publication_type: params[:type]).first_or_create

        @sp_bsb.attributes.keys.each do |key|
          if !['updated_at', 'created_at', 'id'].include?(key) and @pub_sp_bsb.respond_to?("#{key}=") 
            @pub_sp_bsb.send("#{key}=", @sp_bsb[key])
          end
        end
        @pub_sp_bsb.save

        @pub_spdata = PubSpdata.where(spdata_id: bsb.id, sp_bsb_publication_id: @pub_sp_bsb.id).first_or_create
        @spdata = Spdatum.find(bsb.id)
        @spdata.attributes.keys.each do |key|
          if !['updated_at', 'created_at', 'id'].include?(key) and @pub_spdata.respond_to?("#{key}=") 
            @pub_spdata.send("#{key}=", @spdata[key])
          end
        end
        @pub_spdata.spdata_id = bsb.id
        @pub_spdata.save
      end
    end
	end
end
