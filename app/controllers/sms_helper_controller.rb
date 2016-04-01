class SmsHelperController < ApplicationController
  skip_before_action :authenticate_user!

  def send_msg
    if params[:mobile].blank?
      render json: {status: 'ERR', msg: '手机号码不可为空'}
      return
    end

    case params[:type]
      when 'signup'
        code = '%.4i' % rand(9999)
        if send_sms_msg({code: code, product: "#{SysConfig.get(SysConfig::Key::PROV)}食品检验数据报送平台"}, 'SMS_4060612', params[:mobile])
          SmsLog.create(sms_template_code: 'SMS_4060612', mobile: params[:mobile], sms_type: params[:type], msg: code)
        else
          render json: {status: 'ERR', msg: '发送失败'}
          return
        end
      else
        render json: {status: 'ERR', msg: '类型未知'}
        return
    end

    render json: {status: 'OK'}
  end

  private

  API_URL = 'http://gw.api.taobao.com/router/rest?%s'
  TMPL_CODE = {
      SFYZ: 'SMS_4025594',
  }

  def send_sms_msg(params, template_code, mobile)
    form = {method: 'alibaba.aliqin.fc.sms.num.send', app_key: '23293361', timestamp: Time.now.strftime('%Y-%m-%d %H:%M:%S'), format: 'json', v: '2.0', sign_method: 'md5', sms_type: 'normal', sms_free_sign_name: '食品抽检报送平台', sms_param: params.to_json, rec_num: mobile, sms_template_code: template_code}

    form[:sign] = Digest::MD5.hexdigest('eb21d46b595e70ba0c6055bbb6b36781' + form.sort.flatten.join('') + 'eb21d46b595e70ba0c6055bbb6b36781').upcase

    response = JSON.parse(Net::HTTP.get(URI.parse(API_URL % [form.to_query])), :symbolize_names => true)
    result = response[:alibaba_aliqin_fc_sms_num_send_response][:result]
    if result[:err_code].to_i == 0
      return true
    else
      return false
    end
  end
end
