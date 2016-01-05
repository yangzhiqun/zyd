#encoding=UTF-8
class WtypCzbsController < ApplicationController
  include ApplicationHelper
  # GET /wtyp_czbs
  # GET /wtyp_czbs.json
  before_filter :init

  def init
    @cz_options=[["未启动", "未启动"], ["已部署", "已部署"], ["已采取处置措施", "已采取处置措施"], ["处置完毕", "处置完毕"]]
    @czhj_options=[["请选择", ""], ["生产", "生产"], ["流通", "流通"], ["餐饮", "餐饮"]]
    @czrd_options=[["请选择", ""], ["确认企业为真实", "确认企业为真实"], ["认定为假冒企业产品", "认定为假冒企业产品"]]
    @czdealfix1_options=[["请选择", ""], ["封存扣押", "封存扣押"], ["召回下架", "召回下架"], ["停止生产经营", "停止生产经营"]]
    @czdealfix2_options=[["请选择", ""], ["是", "是"], ["否", "否"]]
    @hcczdw_options=[["请选择", ""], ["盒", "盒"], ["袋", "袋"], ["瓶", "瓶"], ["包", "包"], ["箱", "箱"]]
    @hcczwtyy_options=[["人为添加", "人为添加"], ["原料问题", "原料问题"], ["生产工艺", "生产工艺"], ["过程控制不严", "过程控制不严"], ["储运不当", "储运不当"], ["包装迁移", "包装迁移"], ["标签标识问题", "标签标识问题"]]
    @hcczfjjg_options=[["请选择", ""], ["合格", "合格"], ["不合格", "不合格"]]
    @hcczdx_options=[["请选择", ""], ["生产许可", "生产许可"], ["经营许可", "经营许可"], ["餐饮服务许可", "餐饮服务许可"], ["产品许可", "产品许可"]]
  end

  def index

    @begin_at = params[:begin_at].blank? ? (Time.now - 1.year) : DateTime.parse(params[:begin_at]).beginning_of_day
    @end_at = params[:end_at].blank? ? Time.now : DateTime.parse(params[:end_at]).end_of_day

    @wtyp_czbs = WtypCzbPart.where("current_state = ?", params[:state].to_i).order("id, updated_at desc").group('cjbh')

    # 如果不是管理员则进行省份区分 和 安排
    if current_user.hcz_admin != 1
      @wtyp_czbs = @wtyp_czbs.where("((wtyp_czb_type = #{::WtypCzbPart::Type::LT} OR wtyp_czb_type = #{::WtypCzbPart::Type::CY}) AND bcydw_sheng = ?) OR (wtyp_czb_type = #{::WtypCzbPart::Type::SC} AND bsscqy_sheng = ?)", current_user.user_s_province, current_user.user_s_province)
      if params[:state].to_i == 1
        @wtyp_czbs = @wtyp_czbs.where("czfzr = ?", current_user.id)
      end
    end

    @wtyp_czbs = @wtyp_czbs.select('*, count(1) as count').where("updated_at between ? and ?", @begin_at, @end_at)

    # 样品名称
    unless params[:ypmc].blank?
      @wtyp_czbs = @wtyp_czbs.where("ypmc like ?", "%#{params[:ypmc]}%")
    end

    # 被抽样单位名称
    unless params[:bcydwmc].blank?
      @wtyp_czbs = @wtyp_czbs.where("bcydwmc like ?", "%#{params[:bcydwmc]}%")
    end

    # 被抽样单位名称
    unless params[:bcydw_sheng].blank?
      @wtyp_czbs = @wtyp_czbs.where(bcydw_sheng: params[:bcydw_sheng])
    end

    # 表示生产企业名称
    unless params[:bsscqymc].blank?
      @wtyp_czbs = @wtyp_czbs.where("bsscqymc like ?", "%#{params[:bsscqymc]}%")
    end

    # 表示生产企业省份
    unless params[:bsscqy_sheng].blank?
      @wtyp_czbs = @wtyp_czbs.where(bsscqy_sheng: params[:bsscqy_sheng])
    end

    unless params[:cjbh].blank?
      @wtyp_czbs = @wtyp_czbs.where("cjbh like ?", "%#{params[:cjbh]}%")
    end

    unless params[:rwly].blank?
      case params[:rwly].to_i
        when 1
          @wtyp_czbs = @wtyp_czbs.where("cjbh LIKE ?", "____00%")
        when 2
          @wtyp_czbs = @wtyp_czbs.where("cjbh NOT LIKE ?", "____00%")
      end
    end
    @wtyp_czbs = @wtyp_czbs.paginate(:page => params[:page], :per_page => 30)

    # 判断Tab
    case params[:current_tab].to_i
      when 0
        # 任务安排 & 24小时限时报告
        if params[:state].to_i == 0
          # @sp_bsbs = SpBsb.select("sp_s_14,sp_s_16,sp_s_64,sp_s_68,sp_s_71,sp_s_202,sp_s_3,id,updated_at").where("czb_reverted_flag = false AND sp_bsbs.sp_i_state IN (?) AND sp_bsbs.bgfl = '24小时限时报告'", [6, 8, 9]).order("updated_at DESC")
          # if current_user.hcz_admin != 1
          #   @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_3 = ? OR sp_bsbs.sp_s_202 = ?", current_user.user_s_province, current_user.user_s_province)
          # end

          @sp_bsbs = SpBsb.select('sp_s_14, sp_s_16, sp_s_64, sp_s_68, sp_s_71, sp_s_202, sp_s_3, id, updated_at').where("bgfl = '24小时限时报告' AND sp_i_state = 9 AND czb_reverted_flag = 0 AND (sp_s_71 LIKE '%不合格%' OR sp_s_71 LIKE '%问题%')").order('updated_at DESC')

          if current_user.hcz_admin != 1
            #@sp_bsbs = @sp_bsbs.where("id NOT IN (SELECT DISTINCT sp_bsb_id FROM wtyp_czb_parts WHERE (sp_bsb_id IS NOT NULL AND current_state <> 0 AND current_state IS NOT NULL) AND (((wtyp_czb_type = 2 OR wtyp_czb_type = 3) AND bcydw_sheng = ?) OR (wtyp_czb_type = 1 AND bsscqy_sheng = ?))) AND (((sp_s_3 = ? OR sp_s_202 = ?) AND (sp_s_68 = '流通' OR sp_s_68 = '餐饮')) OR (sp_s_202 = ? AND sp_s_68 = '生产'))", current_user.user_s_province, current_user.user_s_province, current_user.user_s_province, current_user.user_s_province, current_user.user_s_province)
            @sp_bsbs = @sp_bsbs.where("id IN (SELECT DISTINCT sp_bsb_id FROM wtyp_czb_parts WHERE (sp_bsb_id IS NULL OR current_state = 0 OR current_state IS NULL) AND (((wtyp_czb_type = 2 OR wtyp_czb_type = 3) AND bcydw_sheng = ?) OR (wtyp_czb_type = 1 AND bsscqy_sheng = ?))) AND (((sp_s_3 = ? OR sp_s_202 = ?) AND (sp_s_68 = '流通' OR sp_s_68 = '餐饮')) OR (sp_s_202 = ? AND sp_s_68 = '生产'))", current_user.user_s_province, current_user.user_s_province, current_user.user_s_province, current_user.user_s_province, current_user.user_s_province)
          else
            # @sp_bsbs = @sp_bsbs.where('id NOT IN (SELECT sp_bsb_id FROM wtyp_czb_parts WHERE (sp_bsb_id IS NOT NULL AND current_state <> 0 AND current_state IS NOT NULL))').group('sp_bsb_id').having('count(1) = 2')
            @sp_bsbs = @sp_bsbs.where('id NOT IN (SELECT sp_bsb_id FROM wtyp_czb_parts WHERE (sp_bsb_id IS NOT NULL AND current_state <> 0 AND current_state IS NOT NULL) group by sp_bsb_id having(count(1))=2)') #.group('sp_bsb_id').having('count(1) = 2')
          end

          # 样品名称
          unless params[:ypmc].blank?
            @sp_bsbs = @sp_bsbs.where("sp_s_14 LIKE ?", "%#{params[:ypmc]}%")
          end

          # 被抽样单位名称
          unless params[:bcydwmc].blank?
            @sp_bsbs = @sp_bsbs.where("sp_s_1 LIKE ?", "%#{params[:bcydwmc]}%")
          end

          # 被抽样单位省
          unless params[:bcydw_sheng].blank?
            @sp_bsbs = @sp_bsbs.where(sp_s_3: params[:bcydw_sheng])
          end

          # 表示生产企业名称
          unless params[:bsscqymc].blank?
            @sp_bsbs = @sp_bsbs.where("sp_s_64 LIKE ?", "%#{params[:bsscqymc]}%")
          end

          # 表示生产企业省份
          unless params[:bsscqy_sheng].blank?
            @sp_bsbs = @sp_bsbs.where(sp_s_202: params[:bsscqy_sheng])
          end

          unless params[:cjbh].blank?
            @sp_bsbs = @sp_bsbs.where("sp_s_16 LIKE ?", "%#{params[:cjbh]}%")
          end

          unless params[:rwly].blank?
            case params[:rwly].to_i
              when 1
                @sp_bsbs = @sp_bsbs.where("sp_s_16 LIKE ?", "____00%")
              when 2
                @sp_bsbs = @sp_bsbs.where("sp_s_16 NOT LIKE ?", "____00%")
            end
          end

          @sp_bsbs = @sp_bsbs.paginate(:page => params[:page], :per_page => 30)

        elsif params[:state].to_i == 1
          # 填报 & 二十四小时限时报告
          @wtyp_czbs = @wtyp_czbs.where(:bgfl => "24小时限时报告")
        end
      when 1
        # 已审核通过
        if params[:state].to_i == 2
          # 已审核报告
          @wtyp_czbs = WtypCzbPart.select('*, count(1) as count ').group('cjbh').where("current_state = ?", ::WtypCzb::State::PASSED).order("id, updated_at desc")

          if current_user.hcz_admin != 1
            @wtyp_czbs = @wtyp_czbs.where("((wtyp_czb_type = #{::WtypCzbPart::Type::LT} OR wtyp_czb_type = #{::WtypCzbPart::Type::CY}) AND bcydw_sheng = ?) OR (wtyp_czb_type = #{::WtypCzbPart::Type::SC} AND bsscqy_sheng = ?)", current_user.user_s_province, current_user.user_s_province)
          end

          # 样品名称
          unless params[:ypmc].blank?
            @wtyp_czbs = @wtyp_czbs.where("ypmc like ?", "%#{params[:ypmc]}%")
          end

          # 被抽样单位名称
          unless params[:bcydwmc].blank?
            @wtyp_czbs = @wtyp_czbs.where("bcydwmc like ?", "%#{params[:bcydwmc]}%")
          end

          # 被抽样单位名称
          unless params[:bcydw_sheng].blank?
            @wtyp_czbs = @wtyp_czbs.where(bcydw_sheng: params[:bcydw_sheng])
          end

          # 表示生产企业名称
          unless params[:bsscqymc].blank?
            @wtyp_czbs = @wtyp_czbs.where("bsscqymc like ?", "%#{params[:bsscqymc]}%")
          end

          # 表示生产企业省份
          unless params[:bsscqy_sheng].blank?
            @wtyp_czbs = @wtyp_czbs.where(bsscqy_sheng: params[:bsscqy_sheng])
          end

          unless params[:cjbh].blank?
            @wtyp_czbs = @wtyp_czbs.where("cjbh like ?", "%#{params[:cjbh]}%")
          end

          unless params[:rwly].blank?
            case params[:rwly].to_i
              when 1
                @wtyp_czbs = @wtyp_czbs.where("cjbh LIKE ?", "____00%")
              when 2
                @wtyp_czbs = @wtyp_czbs.where("cjbh NOT LIKE ?", "____00%")
            end
          end
          @wtyp_czbs = @wtyp_czbs.paginate(:page => params[:page], :per_page => 30)
        elsif params[:state].to_i == 0
          # @sp_bsbs = SpBsb.select("s.sp_s_14,s.sp_s_16,s.sp_s_64,s.sp_s_68,s.sp_s_71,s.sp_s_202,s.sp_s_3,s.id,s.updated_at").joins("AS s LEFT JOIN wtyp_czb_parts as w ON s.id=w.sp_bsb_id").group('s.id').where("w.current_state=0 OR w.current_state IS NULL").where("s.czb_reverted_flag = false AND s.sp_i_state IN (?) AND s.sp_s_71 LIKE ?", [9], "%不合格样品%").order("s.updated_at DESC")
          #
          # if current_user.hcz_admin != 1
          #   @sp_bsbs = @sp_bsbs.where("s.sp_s_3 = ? OR s.sp_s_202 = ?", current_user.user_s_province, current_user.user_s_province)
          #   @sp_bsbs = @sp_bsbs.where("((w.wtyp_czb_type = #{::WtypCzbPart::Type::LT} OR w.wtyp_czb_type = #{::WtypCzbPart::Type::CY}) AND w.bcydw_sheng = ?) OR (w.wtyp_czb_type = #{::WtypCzbPart::Type::SC} AND w.bsscqy_sheng = ?) OR w.wtyp_czb_type IS NULL", session[:user_province], session[:user_province])
          # end

          @sp_bsbs = SpBsb.select('sp_s_14, sp_s_16, sp_s_64, sp_s_68, sp_s_71, sp_s_202, sp_s_3, id, updated_at').where("sp_i_state = 9 AND czb_reverted_flag = 0 AND sp_s_71 LIKE '%不合格%'").order('updated_at DESC')

          if current_user.hcz_admin != 1
            #@sp_bsbs = @sp_bsbs.where("id NOT IN (SELECT DISTINCT sp_bsb_id FROM wtyp_czb_parts WHERE (sp_bsb_id IS NOT NULL AND current_state <> 0 AND current_state IS NOT NULL) AND (((wtyp_czb_type = 2 OR wtyp_czb_type = 3) AND bcydw_sheng = ?) OR (wtyp_czb_type = 1 AND bsscqy_sheng = ?))) AND (((sp_s_3 = ? OR sp_s_202 = ?) AND (sp_s_68 = '流通' OR sp_s_68 = '餐饮')) OR (sp_s_202 = ? AND sp_s_68 = '生产'))", current_user.user_s_province, current_user.user_s_province, current_user.user_s_province, current_user.user_s_province, current_user.user_s_province)
            @sp_bsbs = @sp_bsbs.where("id IN (SELECT DISTINCT sp_bsb_id FROM wtyp_czb_parts WHERE (sp_bsb_id IS NULL OR current_state = 0 OR current_state IS NULL) AND (((wtyp_czb_type = 2 OR wtyp_czb_type = 3) AND bcydw_sheng = ?) OR (wtyp_czb_type = 1 AND bsscqy_sheng = ?))) AND (((sp_s_3 = ? OR sp_s_202 = ?) AND (sp_s_68 = '流通' OR sp_s_68 = '餐饮')) OR (sp_s_202 = ? AND sp_s_68 = '生产'))", current_user.user_s_province, current_user.user_s_province, current_user.user_s_province, current_user.user_s_province, current_user.user_s_province)
          else
            @sp_bsbs = @sp_bsbs.where('id NOT IN (SELECT sp_bsb_id FROM wtyp_czb_parts WHERE (sp_bsb_id IS NOT NULL AND current_state <> 0 AND current_state IS NOT NULL) group by sp_bsb_id having(count(1))=2)') #.group('sp_bsb_id').having('count(1) = 2')
          end

          # 样品名称
          unless params[:ypmc].blank?
            @sp_bsbs = @sp_bsbs.where("sp_s_14 LIKE ?", "%#{params[:ypmc]}%")
          end

          # 被抽样单位名称
          unless params[:bcydwmc].blank?
            @sp_bsbs = @sp_bsbs.where("sp_s_1 LIKE ?", "%#{params[:bcydwmc]}%")
          end

          # 被抽样单位省
          unless params[:bcydw_sheng].blank?
            @sp_bsbs = @sp_bsbs.where("sp_s_3 = ?", params[:bcydw_sheng])
          end

          # 表示生产企业名称
          unless params[:bsscqymc].blank?
            @sp_bsbs = @sp_bsbs.where("sp_s_64 LIKE ?", "%#{params[:bsscqymc]}%")
          end

          # 表示生产企业省份
          unless params[:bsscqy_sheng].blank?
            @sp_bsbs = @sp_bsbs.where("sp_s_202 = ?", params[:bsscqy_sheng])
          end

          unless params[:cjbh].blank?
            @sp_bsbs = @sp_bsbs.where("sp_s_16 LIKE ?", "%#{params[:cjbh]}%")
          end

          unless params[:rwly].blank?
            case params[:rwly].to_i
              when 1
                @sp_bsbs = @sp_bsbs.where("sp_s_16 LIKE ?", "____00%")
              when 2
                @sp_bsbs = @sp_bsbs.where("sp_s_16 NOT LIKE ?", "____00%")
            end
          end
          @sp_bsbs = @sp_bsbs.paginate(:page => params[:page], :per_page => 30)
        else
          # 一般不合格报告
          @wtyp_czbs = @wtyp_czbs.where("jyjl LIKE ?", "%不合格样品%")
          logger.error @wtyp_czbs.to_sql

          if current_user.hcz_admin != 1 and params[:state].to_i == 1
            @wtyp_czbs = @wtyp_czbs.where("czfzr = ?", current_user.id)
          end
        end
      when 2
        # 合格报告
        # @wtyp_czbs = @wtyp_czbs.where(:bgfl => "合格报告")
      when 3
        # 已安排Tab
        case params[:state].to_i
          when ::WtypCzb::State::LOGGED
            @wtyp_czbs = WtypCzbPart.group('cjbh').where("current_state = ?", ::WtypCzb::State::ASSIGNED).order("id, updated_at desc")
          when ::WtypCzb::State::ASSIGNED
            @wtyp_czbs = WtypCzbPart.group('cjbh').where("current_state = ?", ::WtypCzb::State::FILLED).order("id, updated_at desc")
          when ::WtypCzb::State::FILLED
            @wtyp_czbs = WtypCzbPart.group('cjbh').where("current_state = ?", ::WtypCzb::State::PASSED).order("id, updated_at desc")
        end
        @wtyp_czbs = @wtyp_czbs.select("*, count(1) as count")

        if current_user.hcz_admin != 1
          @wtyp_czbs = @wtyp_czbs.where("((wtyp_czb_type = #{::WtypCzbPart::Type::LT} OR wtyp_czb_type = #{::WtypCzbPart::Type::CY}) AND bcydw_sheng = ?) OR (wtyp_czb_type = #{::WtypCzbPart::Type::SC} AND bsscqy_sheng = ?)", current_user.user_s_province, current_user.user_s_province)

          if params[:state].to_i == 1
            @wtyp_czbs = @wtyp_czbs.where("czfzr = ?", current_user.id)
          end
        end

        # 样品名称
        unless params[:ypmc].blank?
          @wtyp_czbs = @wtyp_czbs.where("ypmc like ?", "%#{params[:ypmc]}%")
        end

        # 被抽样单位名称
        unless params[:bcydwmc].blank?
          @wtyp_czbs = @wtyp_czbs.where("bcydwmc like ?", "%#{params[:bcydwmc]}%")
        end

        # 被抽样单位名称
        unless params[:bcydw_sheng].blank?
          @wtyp_czbs = @wtyp_czbs.where(bcydw_sheng: params[:bcydw_sheng])
        end

        # 表示生产企业名称
        unless params[:bsscqymc].blank?
          @wtyp_czbs = @wtyp_czbs.where("bsscqymc like ?", "%#{params[:bsscqymc]}%")
        end

        # 表示生产企业省份
        unless params[:bsscqy_sheng].blank?
          @wtyp_czbs = @wtyp_czbs.where(bsscqy_sheng: params[:bsscqy_sheng])
        end

        unless params[:cjbh].blank?
          @wtyp_czbs = @wtyp_czbs.where("cjbh like ?", "%#{params[:cjbh]}%")
        end

        unless params[:rwly].blank?
          case params[:rwly].to_i
            when 1
              @wtyp_czbs = @wtyp_czbs.where("cjbh LIKE ?", "____00%")
            when 2
              @wtyp_czbs = @wtyp_czbs.where("cjbh NOT LIKE ?", "____00%")
          end
        end
        @wtyp_czbs = @wtyp_czbs.paginate(:page => params[:page], :per_page => 30)
      when 4
        if params[:state].to_i == 0
          # 一般问题报告
          # @sp_bsbs = SpBsb.joins("AS s LEFT JOIN wtyp_czb_parts as w ON s.id=w.sp_bsb_id").select('s.*').group('s.id').where("w.current_state=0 OR w.current_state IS NULL").where("s.czb_reverted_flag = false AND s.sp_i_state IN (?) AND s.sp_s_71 LIKE ?", [9], "%问题样品%").order("s.updated_at DESC")
          #
          # if current_user.hcz_admin != 1
          #   @sp_bsbs = @sp_bsbs.where("s.sp_s_3 = ? OR s.sp_s_202 = ?", current_user.user_s_province, current_user.user_s_province)
          #   @sp_bsbs = @sp_bsbs.where("((w.wtyp_czb_type = #{::WtypCzbPart::Type::LT} OR w.wtyp_czb_type = #{::WtypCzbPart::Type::CY}) AND w.bcydw_sheng = ?) OR (w.wtyp_czb_type = #{::WtypCzbPart::Type::SC} AND w.bsscqy_sheng = ?) OR w.wtyp_czb_type IS NULL", session[:user_province], session[:user_province])
          # end

          @sp_bsbs = SpBsb.select('sp_s_14, sp_s_16, sp_s_64, sp_s_68, sp_s_71, sp_s_202, sp_s_3, id, updated_at').where("sp_i_state = 9 AND czb_reverted_flag = 0 AND sp_s_71 LIKE '%问题%'").order('updated_at DESC')

          if current_user.hcz_admin != 1
            #@sp_bsbs = @sp_bsbs.where("id NOT IN (SELECT DISTINCT sp_bsb_id FROM wtyp_czb_parts WHERE (sp_bsb_id IS NOT NULL AND current_state <> 0 AND current_state IS NOT NULL) AND (((wtyp_czb_type = 2 OR wtyp_czb_type = 3) AND bcydw_sheng = ?) OR (wtyp_czb_type = 1 AND bsscqy_sheng = ?))) AND (((sp_s_3 = ? OR sp_s_202 = ?) AND (sp_s_68 = '流通' OR sp_s_68 = '餐饮')) OR (sp_s_202 = ? AND sp_s_68 = '生产'))", current_user.user_s_province, current_user.user_s_province, current_user.user_s_province, current_user.user_s_province, current_user.user_s_province)
            @sp_bsbs = @sp_bsbs.where("id IN (SELECT DISTINCT sp_bsb_id FROM wtyp_czb_parts WHERE (sp_bsb_id IS NULL OR current_state =0 OR current_state IS NULL) AND (((wtyp_czb_type = 2 OR wtyp_czb_type = 3) AND bcydw_sheng = ?) OR (wtyp_czb_type = 1 AND bsscqy_sheng = ?))) AND (((sp_s_3 = ? OR sp_s_202 = ?) AND (sp_s_68 = '流通' OR sp_s_68 = '餐饮')) OR (sp_s_202 = ? AND sp_s_68 = '生产'))", current_user.user_s_province, current_user.user_s_province, current_user.user_s_province, current_user.user_s_province, current_user.user_s_province)
          else
            # @sp_bsbs = @sp_bsbs.where('id NOT IN (SELECT sp_bsb_id FROM wtyp_czb_parts WHERE (sp_bsb_id IS NOT NULL AND current_state <> 0 AND current_state IS NOT NULL))').group('sp_bsb_id').having('count(1) = 2')
            @sp_bsbs = @sp_bsbs.where('id NOT IN (SELECT sp_bsb_id FROM wtyp_czb_parts WHERE (sp_bsb_id IS NOT NULL AND current_state <> 0 AND current_state IS NOT NULL) group by sp_bsb_id having(count(1))=2)') #.group('sp_bsb_id').having('count(1) = 2')
          end

          # 样品名称
          unless params[:ypmc].blank?
            @sp_bsbs = @sp_bsbs.where("sp_s_14 LIKE ?", "%#{params[:ypmc]}%")
          end

          # 被抽样单位名称
          unless params[:bcydwmc].blank?
            @sp_bsbs = @sp_bsbs.where("sp_s_1 LIKE ?", "%#{params[:bcydwmc]}%")
          end

          # 被抽样单位省
          unless params[:bcydw_sheng].blank?
            @sp_bsbs = @sp_bsbs.where(sp_s_3: params[:bcydw_sheng])
          end

          # 表示生产企业名称
          unless params[:bsscqymc].blank?
            @sp_bsbs = @sp_bsbs.where("sp_s_64 LIKE ?", "%#{params[:bsscqymc]}%")
          end

          # 表示生产企业省份
          unless params[:bsscqy_sheng].blank?
            @sp_bsbs = @sp_bsbs.where(sp_s_202: params[:bsscqy_sheng])
          end

          unless params[:cjbh].blank?
            @sp_bsbs = @sp_bsbs.where("sp_s_16 LIKE ?", "%#{params[:cjbh]}%")
          end

          unless params[:rwly].blank?
            case params[:rwly].to_i
              when 1
                @sp_bsbs = @sp_bsbs.where("sp_s_16 LIKE ?", "____00%")
              when 2
                @sp_bsbs = @sp_bsbs.where("sp_s_16 NOT LIKE ?", "____00%")
            end
          end

          @sp_bsbs = @sp_bsbs.paginate(:page => params[:page], :per_page => 30)
        else
          # 一般问题报告
          @wtyp_czbs = @wtyp_czbs.where("jyjl LIKE ?", "%问题样品%")

          if current_user.hcz_admin != 1 and params[:state].to_i == 1
            @wtyp_czbs = @wtyp_czbs.where("czfzr = ?", current_user.id)
          end
        end
      when 5
        @wtyp_czbs = WtypCzbPart.select("*, count(1) as count").group('cjbh').where("current_state = ?", ::WtypCzb::State::PASSED).order("id, updated_at desc")

        if current_user.hcz_admin != 1
          @wtyp_czbs = @wtyp_czbs.where("((wtyp_czb_type = #{::WtypCzbPart::Type::LT} OR wtyp_czb_type = #{::WtypCzbPart::Type::CY}) AND bcydw_sheng = ?) OR (wtyp_czb_type = #{::WtypCzbPart::Type::SC} AND bsscqy_sheng = ?)", current_user.user_s_province, current_user.user_s_province)
        end

        # 样品名称
        unless params[:ypmc].blank?
          @wtyp_czbs = @wtyp_czbs.where("ypmc like ?", "%#{params[:ypmc]}%")
        end

        # 被抽样单位名称
        unless params[:bcydwmc].blank?
          @wtyp_czbs = @wtyp_czbs.where("bcydwmc like ?", "%#{params[:bcydwmc]}%")
        end

        # 被抽样单位名称
        unless params[:bcydw_sheng].blank?
          @wtyp_czbs = @wtyp_czbs.where(bcydw_sheng: params[:bcydw_sheng])
        end

        # 表示生产企业名称
        unless params[:bsscqymc].blank?
          @wtyp_czbs = @wtyp_czbs.where("bsscqymc like ?", "%#{params[:bsscqymc]}%")
        end

        # 表示生产企业省份
        unless params[:bsscqy_sheng].blank?
          @wtyp_czbs = @wtyp_czbs.where(bsscqy_sheng: params[:bsscqy_sheng])
        end

        unless params[:cjbh].blank?
          @wtyp_czbs = @wtyp_czbs.where("cjbh like ?", "%#{params[:cjbh]}%")
        end

        unless params[:rwly].blank?
          case params[:rwly].to_i
            when 1
              @wtyp_czbs = @wtyp_czbs.where("cjbh LIKE ?", "____00%")
            when 2
              @wtyp_czbs = @wtyp_czbs.where("cjbh NOT LIKE ?", "____00%")
          end
        end
        @wtyp_czbs = @wtyp_czbs.paginate(:page => params[:page], :per_page => 30)
      when 6
        @wtyp_czbs = @wtyp_czbs.where("part_submit_flag1 = 1 OR part_submit_flag2 = 1 OR part_submit_flag3 = 1")

        if current_user.hcz_admin != 1 and params[:state].to_i == 1
          @wtyp_czbs = @wtyp_czbs.where("czfzr = ?", current_user.id)
        end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @wtyp_czbs }
    end
  end

  # GET /wtyp_czbs/1
  # GET /wtyp_czbs/1.json
  def show
    @wtyp_czb = WtypCzb.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @wtyp_czb }
    end
  end

  def edit
    @sp_bsb=SpBsb.find(params[:id])

    @wtyp_czb = WtypCzb.find_by_wtyp_sp_bsbs_id(@sp_bsb.id)

    if @wtyp_czb.nil?
      @wtyp_czb = WtypCzb.new
      @wtyp_czb.wtyp_sp_bsbs_id = @sp_bsb.id
      @wtyp_czb.cjbh = @sp_bsb.sp_s_16
      @wtyp_czb.ypmc = @sp_bsb.sp_s_14
      @wtyp_czb.ypgg = @sp_bsb.sp_s_26
      @wtyp_czb.ypph = @sp_bsb.sp_s_27
      @wtyp_czb.bcydwmc = @sp_bsb.sp_s_1
      @wtyp_czb.bcydw_sheng = @sp_bsb.sp_s_3
      @wtyp_czb.cydwmc = @sp_bsb.sp_s_35
      @wtyp_czb.cydwsf = @sp_bsb.sp_s_52
      @wtyp_czb.bsscqymc = @sp_bsb.sp_s_64
      @wtyp_czb.bsscqy_sheng = @sp_bsb.sp_s_202
      @wtyp_czb.scrq = @sp_bsb.sp_d_28
      @wtyp_czb.bgfl = @sp_bsb.bgfl
      @wtyp_czb.jyjl = @sp_bsb.sp_s_71
      @wtyp_czb.bgsbh = @sp_bsb.sp_s_45
      @wtyp_czb.cydd = @sp_bsb.sp_s_68
      @wtyp_czb.bcydwdz = @sp_bsb.sp_s_7
      @wtyp_czb.bsscqydz = @sp_bsb.sp_s_65
      @wtyp_czb.cyjs = @sp_bsb.sp_s_206
      @wtyp_czb.jymd = @sp_bsb.sp_s_44
      # TODO: 要做好事务处理 2015-04-25
      if @wtyp_czb.save
        @spdata = []
        @sp_bsb.spdata.each do |data|
          if data.spdata_2.include? "问题" or data.spdata_2.include? "不合格"
            hczdata = SpHczSpdata.new
            hczdata.spdata_0 = data.spdata_0
            hczdata.spdata_1 = data.spdata_1
            hczdata.spdata_2 = data.spdata_2
            hczdata.spdata_3 = data.spdata_3
            hczdata.spdata_4 = data.spdata_4
            hczdata.spdata_5 = data.spdata_5
            hczdata.spdata_6 = data.spdata_6
            hczdata.spdata_7 = data.spdata_7
            hczdata.spdata_8 = data.spdata_8
            hczdata.spdata_9 = data.spdata_9
            hczdata.spdata_10 = data.spdata_10
            hczdata.spdata_11 = data.spdata_11
            hczdata.spdata_12 = data.spdata_12
            hczdata.spdata_13 = data.spdata_13
            hczdata.spdata_14 = data.spdata_14
            hczdata.spdata_15 = data.spdata_15
            hczdata.spdata_16 = data.spdata_16
            hczdata.spdata_17 = data.spdata_17
            hczdata.spdata_18 = data.spdata_18
            hczdata.wtyp_czb_id = @wtyp_czb.id
            hczdata.save
          end
        end
      end
    end

    # 生产部分
    # 生产部分核查处置仅包含：生产 & 流通
    if !@sp_bsb.sp_s_68.eql?("餐饮")
      @part_sc = WtypCzbPart.where(wtyp_czb_type: WtypCzbPart::Type::SC, wtyp_czb_id: @wtyp_czb.id).first
      if @part_sc.nil?
        @part_sc = WtypCzbPart.new(wtyp_czb_type: WtypCzbPart::Type::SC, wtyp_czb_id: @wtyp_czb.id)
        @part_sc.sp_bsb_id = @sp_bsb.id
        @part_sc.cjbh = @sp_bsb.sp_s_16
        @part_sc.ypmc = @sp_bsb.sp_s_14
        @part_sc.ypgg = @sp_bsb.sp_s_26
        @part_sc.ypph = @sp_bsb.sp_s_27
        @part_sc.bcydwmc = @sp_bsb.sp_s_1
        @part_sc.bcydw_sheng = @sp_bsb.sp_s_3
        @part_sc.cydwmc = @sp_bsb.sp_s_35
        @part_sc.cydwsf = @sp_bsb.sp_s_52
        @part_sc.bsscqymc = @sp_bsb.sp_s_64
        @part_sc.bsscqy_sheng = @sp_bsb.sp_s_202
        @part_sc.scrq = @sp_bsb.sp_d_28
        @part_sc.bgfl = @sp_bsb.bgfl
        @part_sc.jyjl = @sp_bsb.sp_s_71
        @part_sc.bgsbh = @sp_bsb.sp_s_45
        @part_sc.cydd = @sp_bsb.sp_s_68
        @part_sc.bcydwdz = @sp_bsb.sp_s_7
        @part_sc.bsscqydz = @sp_bsb.sp_s_65
        @part_sc.current_state = 0
        @part_sc.cyjs = @sp_bsb.sp_s_206
        @part_sc.jymd = @sp_bsb.sp_s_44
        @part_sc.session = session
        @part_sc.save
      end
    end

    # [流通/餐饮]部分
    if @sp_bsb.sp_s_68.eql?("流通")
      @lt_cy_type = WtypCzbPart::Type::LT
    elsif @sp_bsb.sp_s_68.eql?("餐饮")
      @lt_cy_type = WtypCzbPart::Type::CY
    end

    @part_lt_cy = WtypCzbPart.where(wtyp_czb_type: @lt_cy_type, wtyp_czb_id: @wtyp_czb.id).first
    # #47 第10条，如果抽样环节是生产，则只处理生产，不处理流通
    if @part_lt_cy.nil? and !@sp_bsb.sp_s_68.eql?("生产")
      @part_lt_cy = WtypCzbPart.new(wtyp_czb_type: @lt_cy_type, wtyp_czb_id: @wtyp_czb.id)
      @part_lt_cy.sp_bsb_id = @sp_bsb.id
      @part_lt_cy.cjbh = @sp_bsb.sp_s_16
      @part_lt_cy.ypmc = @sp_bsb.sp_s_14
      @part_lt_cy.ypgg = @sp_bsb.sp_s_26
      @part_lt_cy.ypph = @sp_bsb.sp_s_27
      @part_lt_cy.bcydwmc = @sp_bsb.sp_s_1
      @part_lt_cy.bcydw_sheng = @sp_bsb.sp_s_3
      @part_lt_cy.cydwmc = @sp_bsb.sp_s_35
      @part_lt_cy.cydwsf = @sp_bsb.sp_s_52
      @part_lt_cy.bsscqymc = @sp_bsb.sp_s_64
      @part_lt_cy.bsscqy_sheng = @sp_bsb.sp_s_202
      @part_lt_cy.scrq = @sp_bsb.sp_d_28
      @part_lt_cy.bgfl = @sp_bsb.bgfl
      @part_lt_cy.jyjl = @sp_bsb.sp_s_71
      @part_lt_cy.bgsbh = @sp_bsb.sp_s_45
      @part_lt_cy.cydd = @sp_bsb.sp_s_68
      @part_lt_cy.bcydwdz = @sp_bsb.sp_s_7
      @part_lt_cy.bsscqydz = @sp_bsb.sp_s_65
      @part_lt_cy.cyjs = @sp_bsb.sp_s_206
      @part_lt_cy.jymd = @sp_bsb.sp_s_44
      @part_lt_cy.current_state = 0
      @part_lt_cy.session = session
      @part_lt_cy.save
    end

    @is_editing = WtypCzbPart.where("bcydw_sheng = ? OR bsscqy_sheng = ? AND wtyp_czb_id = ?", current_user.user_s_province, current_user.user_s_province, @wtyp_czb.id).where("current_state = ?", ::WtypCzb::State::ASSIGNED).count > 0

    @yydjb = SpYydjb.where("cjbh = ? AND current_state IN (1, 2, 3)", @sp_bsb.sp_s_16).last

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @wtyp_czb }
    end
  end

  # POST /wtyp_czbs
  # POST /wtyp_czbs.json
  def create
    @wtyp_czb = WtypCzb.new(params[:wtyp_czb])

    @wtyp_czb.current_state = ::WtypCzb::State::LOGGED
    result_record=WtypCzb.where("wtyp_sp_bsbs_id=? and wtyp_czb_type = ?", params[:wtyp_czb][:wtyp_sp_bsbs_id], @wtyp_czb.wtyp_czb_type).last
    respond_to do |format|
      if result_record==nil
        @sp_bsb=SpBsb.find(params[:wtyp_czb][:wtyp_sp_bsbs_id])
        if params[:wtyp_czb][:wtyp_no]=='1'
          SpBsb.record_timestamps = false
          @sp_bsb.update_attribute('sp_s_202', params[:sp_sf])
          SpBsb.record_timestamps = true
        end
        if @wtyp_czb.save
          @spdata = @sp_bsb.spdata
          @spdata.each do |data|
            if data.spdata_2.include? "问题" or data.spdata_2.include? "不合格"
              hczdata = SpHczSpdata.new
              hczdata.spdata_0 = data.spdata_0
              hczdata.spdata_1 = data.spdata_1
              hczdata.spdata_2 = data.spdata_2
              hczdata.spdata_3 = data.spdata_3
              hczdata.spdata_4 = data.spdata_4
              hczdata.spdata_5 = data.spdata_5
              hczdata.spdata_6 = data.spdata_6
              hczdata.spdata_7 = data.spdata_7
              hczdata.spdata_8 = data.spdata_8
              hczdata.spdata_9 = data.spdata_9
              hczdata.spdata_10 = data.spdata_10
              hczdata.spdata_11 = data.spdata_11
              hczdata.spdata_12 = data.spdata_12
              hczdata.spdata_13 = data.spdata_13
              hczdata.spdata_14 = data.spdata_14
              hczdata.spdata_15 = data.spdata_15
              hczdata.spdata_16 = data.spdata_16
              hczdata.spdata_17 = data.spdata_17
              hczdata.spdata_18 = data.spdata_18
              hczdata.sp_hcz_id = @wtyp_czb.id
              hczdata.save
            end
          end
          format.html { redirect_to "/wtyp_czbs/#{@wtyp_czb.wtyp_sp_bsbs_id}/edit" }
          format.json { render json: @wtyp_czb, status: :created, location: @wtyp_czb }
        else
          format.html { render action: "new" }
          format.json { render json: @wtyp_czb.errors, status: :unprocessable_entity }
        end
      else
        flash[:edit_result] = "新建处理不成功，该样品已处理，请刷新!"
        format.html { redirect_to "/sp_bsbs" }
      end
    end
  end

  # PUT /wtyp_czbs/1
  # PUT /wtyp_czbs/1.json
  def update
    @wtyp_czb = WtypCzb.find(params[:id])
    @sp_bsb = SpBsb.find(@wtyp_czb.wtyp_sp_bsbs_id)

    respond_to do |format|

      params[:parts].each do |part|
        next if part[:wtyp_czb_id].blank?
        next if part[:save_me].to_i == 0

        @wtyp_czb_part = WtypCzbPart.where(wtyp_czb_type: part[:wtyp_czb_type], wtyp_czb_id: part[:wtyp_czb_id]).first

        @wtyp_czb_part.session = session

        @wtyp_czb_part.update_attributes(part.permit(:wtyp_czb_id, :wtyp_contacts, :wtyp_date, :wtyp_deal_detail, :wtyp_deal_jg, :wtyp_deal_way, :wtyp_email, :wtyp_fax, :wtyp_jg, :wtyp_remark, :wtyp_state, :wtyp_tel, :wtyp_verify, :wtyp_sp_bsbs_id, :wtyp_no, :wtyp_deal_segment, :wtyp_deal_affirm, :wtyp_deal_site, :wtyp_deal_result, :wtyp_deal_fix1way, :wtyp_deal_fix2way, :wtyp_deal_fix3way, :wtyp_result_fix1way, :wtyp_result_fix2way, :wtyp_result_fix3way, :wtyp_result_fix4way, :wtyp_result_fix5way, :wtyp_result_fix6way, :wtyp_result_fix7way, :wtyp_result_fix8way, :current_state, :czb_type, :bcydw_sheng, :bsscqy_sheng, :yyzt, :yyfl, :yyczjg, :fjzt, :fjsqr, :fjsqsj, :fjslrq, :fjwcsj, :fjjgou, :blbm, :blr, :blsj, :tbbm, :tbr, :tbsj, :shbm, :shr, :shsj, :cjbh, :ypmc, :ypgg, :ypph, :jyjl, :bcydwmc, :cydwmc, :cydwsf, :bsscqymc, :scrq, :yytcr, :yytcsj, :yysdsj, :yynr, :djbm, :djr, :djsj, :fjsqzk, :bgfl, :yyczqk, :thyy, :czbm, :czfzr, :bgsbh, :cydd, :bcydwdz, :bsscqydz, :cyjs, :jymd, :jyjgzt, :bgfl, :qdhcczrq, :shbm, :czwbrq, :fxpj_1, :fxpj_2, :fxpj_3, :fxpj_4, :cpkzqk_1, :cpkzqk_2, :cpkzqk_3, :cpkzqk_4, :cpkzqk_5, :cpkzqk_6, :cpkzqk_7, :cpkzqk_8, :cpkzqk_9, :cpkzqk_10, :cpkzqk_11, :cpkzqk_12, :cpkzqk_13, :cpkzqk_14, :cpkzqk_15, :cpkzqk_16, :cpkzqk_17, :cpkzqk_18, :cpkzqk_19, :cpkzqk_20, :cpkzqk_21, :cpkzqk_22, :cpkzqk_23, :pczgfc_1, :pczgfc_2, :pczgfc_3, :pczgfc_4, :pczgfc_5, :pczgfc_6, :pczgfc_7, :pczgfc_8, :pczgfc_9, :xzcfqk_1, :xzcfqk_2, :xzcfqk_3, :xzcfqk_4, :xzcfqk_5, :xzcfqk_6, :xzcfqk_7, :xzcfqk_8, :xzcfqk_9, :xzcfqk_10, :xzcfqk_11, :xzcfqk_12, :xzcfqk_13, :xzcfqk_14, :xzcfqk_15, :xzcfqk_16, :xzcfqk_17, :xzcfqk_18, :xzcfqk_19, :xzcfqk_20, :xzcfqk_21, :hccz_type, :part_submit_flag1, :part_submit_flag2, :part_submit_flag3, :part_submit_flag4, :wtyp_czb_type, :sp_bsb_id, :pczgfc_10, :pczgfc_11, :pczgfc_12, :pczgfc_13, :pczgfc_14, :pczgfc_15, :pczgfc_16, :pczgfc_17, :current_state_desc, :tmp_save, :part_submit, :save_me))
      end

      format.html { redirect_to :back }
    end
  end

  # DELETE /wtyp_czbs/1
  # DELETE /wtyp_czbs/1.json
  def destroy
    @wtyp_czb = WtypCzb.find(params[:id])
    @wtyp_czb.destroy

    respond_to do |format|
      format.html { redirect_to wtyp_czbs_url }
      format.json { head :no_content }
    end
  end

  def assign_task
    respond_to do |format|
      @czbs = WtypCzbPart.where(:id => params[:ids].split(','))

      if @czbs.update_all(:czbm => params[:czbm], :czfzr => params[:czfzr], :current_state => WtypCzb::State::ASSIGNED, :blr => current_user.tname, :blbm => current_user.jg_bsb.jg_name, :blsj => Time.now)
        format.json { render :json => {:status => 'OK'} }
      else
        format.json { render :json => {:status => 'ERR', :msg => '失败！'} }
      end
    end
  end

  def revert

    if params[:is_ap].eql?("true")
      SpBsb.record_timestamps = false
      @sp_bsbs = SpBsb.where(id: params[:ids].split(','))
      @sp_bsbs.each do |bsb|
        bsb.update_attributes("czb_reverted_flag" => true, "czb_reverted_reason" => "操作时间：" + Time.now.to_s + ", 原因：" + params[:thyy] + ", 操作人员：" + session[:user_tname])
      end
      SpBsb.record_timestamps = true
    else
      @wtyp_czbs = WtypCzbPart.where(:id => params[:ids].split(','))

      @wtyp_czbs.each do |czb|
        czb.thyy = (czb.thyy || "") + "<br>" + "操作时间：" + Time.now.to_s + ", 原因：" + params[:thyy] + ", 操作人员：" + current_user.tname
        czb.session = session
        czb.reverting = true
        case czb.current_state
          when ::WtypCzb::State::LOGGED
            czb.current_state = ::WtypCzb::State::CANCEL
          when ::WtypCzb::State::ASSIGNED
            czb.current_state = ::WtypCzb::State::LOGGED
          when ::WtypCzb::State::FILLED
            czb.current_state = ::WtypCzb::State::ASSIGNED
            czb.part_submit_flag1 = false
            czb.part_submit_flag2 = false
            czb.part_submit_flag3 = false
            czb.part_submit_flag4 = false

          when SpYydjb::State::PASSED
            czb.current_state = ::WtypCzb::State::FILLED
        end
        czb.save
      end
    end

    respond_to do |format|
      format.json { render :json => {:status => 'OK', :msg => ''} }
    end
  end
end

