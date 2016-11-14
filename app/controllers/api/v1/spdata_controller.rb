#encoding: utf-8
class Api::V1::SpdataController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:transfer]
	skip_before_action :authenticate_user!

	module ErrorCode	
		None = 0							 #正确
		ParamsParseError = 1	 #没有参数
		CjbhError = 2					 #抽检编号找不到
		StateError = 3         #状态错误
		DetectionTypeError = 4 #检测类型不匹配 
		ItemError = 5          #item插入错误
		OtherError = 6         #其他错误
	end

	attr_accessor :error_hash

  # 接口提交数据
  # /api/v1/spdata/transfer
  def transfer
    #respond_to do |format|
			self.error_hash = {"result":{"code": "0","msg":""},"detail":[]}
      begin
				params_h = params.symbolize_keys
				# code: 1:全部插入成功；0：全部插入失败；2：部分成功
				# msg:  当有特殊原因造成全部插入失败时，写此字段，例如：数据库无法连接
				p "-"*50
				p params_h
				p "-"*50
				if params_h[:data].blank?
					self.error_hash[:result][:msg] = "请提供data参数"
          #format.json { 
						render :json => self.error_hash
						return
					#}
				end

				# 获取抽检结果
				if params_h[:data].class.to_s.eql?("String")
					@data = JSON.parse(params_h[:data], :symbolize_keys => true)
				else
					@data = params_h[:data]
				end
				
				@data_num  = @data.length  #记录抽检数量
				@error_num = 0						 #抽检错误数量
				@items     = 0						 #items总数
				@items_err = 0						 #item错误总数
				@data.each do |data|	
					p "<"*100
					p data
					p "<"*100
					@spbsb = SpBsb.find_by_sp_s_16(data["cjbh"])
					if @spbsb.nil?
						@error_num += 1
						self.error_hash[:detail] << {"cjbh":data["cjbh"],"itemId":"","error_code":ErrorCode::CjbhError,"msg":"没有该抽检编号"}
					else
						if @spbsb.sp_i_state != 2
							@error_num += 1
							self.error_hash[:detail] << {"cjbh":data["cjbh"],"itemId":"","error_code":ErrorCode::StateError,"msg":"状态不正确"}
						else
							@items += data["items"].length
							data["items"].each do |item|
								one   = item["level1"] == @spbsb.sp_s_17
								two   = item["level2"] == @spbsb.sp_s_18
								three = item["level3"] == @spbsb.sp_s_19
								four  = item["level4"] == @spbsb.sp_s_20
								if one && two && three && four 							
									@spdata = Spdatum.new()
									@spdata.spdata_1  = item["spdata_1"] 
									@spdata.spdata_2  = item["spdata_2"] 
									@spdata.spdata_17 = item["spdata_17"] 
									@spdata.sp_bsb_id = @spbsb.id	
									unless @spdata.save
										@items_err += 1
										self.error_hash[:detail] << {"cjbh":data["cjbh"],"itemId":item["itemId"],"error_code":ErrorCode::ItemError,"msg": @spdata.errors}	
									end
								else	
									@items_err += 1
									self.error_hash[:detail] << {"cjbh":data["cjbh"],"itemId":item["itemId"],"error_code":ErrorCode::DetectionTypeError,"msg":"检测类型不匹配"}
								end
							end
						end
					end
				end
			  
				# 结果
        #format.json { 
					if @error_num == 0 && @items_err == 0
						self.error_hash[:result][:code]	= "1"
					elsif @error_num != @data_num && @items != @items_err
						self.error_hash[:result][:code] = "2"
					end
					render :json => self.error_hash
					return
			  #}
			rescue Exception => e
				self.error_hash[:result][:msg] = e.message
        #format.json { 
					render :json => self.error_hash
					return
				#}
			end
    #end
  end
end
