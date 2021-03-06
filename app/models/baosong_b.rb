#encoding: utf-8
class BaosongB < ActiveRecord::Base
  # attr_accessible :baosong_a_id, :name, :note, :identifier, :file, :prov

  validates_presence_of :baosong_a_id, :message => "报送分类A不可为空"
  validates_presence_of :name, :message => "名称不可为空"
  #validates_presence_of :file, :message => "Excel源文件不可为空", on: [:create]

  belongs_to :baosong_a
  has_many :a_categories, primary_key: :identifier, foreign_key: :identifier, dependent: :delete_all
  has_many :b_categories, primary_key: :identifier, foreign_key: :identifier, dependent: :delete_all
  has_many :c_categories, primary_key: :identifier, foreign_key: :identifier, dependent: :delete_all
  has_many :d_categories, primary_key: :identifier, foreign_key: :identifier, dependent: :delete_all

  has_many :task_jg_bsb, primary_key: :identifier, foreign_key: :identifier, dependent: :delete_all
  has_many :task_province, primary_key: :identifier, foreign_key: :identifier, dependent: :delete_all
  def a_categories
    ACategory.where(identifier: self.identifier)
  end

  module CategoryType
    A = 0
    B = 1
    C = 2
    D = 3
  end

  def file
    @file
  end

  def file=(file)
    @file = file
    unless file.nil?
      book = Spreadsheet.open(file.path)

      sheet = book.worksheet(0)

      @lines = []
      sheet.each_with_index 1 do |row, index|
        # 大类
        @A_category = row[0].to_s.delete("\n").strip unless row[0].nil?
        # 亚类
        @B_category = row[1].to_s.delete("\n").strip unless row[1].nil?
        # 次亚类
        @C_category = row[2].to_s.delete("\n").strip unless row[2].nil?
        # 细类
        @D_category = row[3].to_s.delete("\n").strip unless row[3].nil?

        # 检验项目
        unless row[6].nil?
        @JYXM = row[6].to_s.delete("\n").strip
        else
        @JYXM = "/"
        end
        # 结果单位
        unless row[8].nil?
        @JGDW = row[8].to_s.delete("\n").strip
        else
         @JGDW ="/"
        end

        # 排出非合并项
        # @JGDW = nil if (row[8].nil? and row.format(8).top != :none)

        # 判定依据
        unless row[11].nil?
        @PDYJ = row[11].to_s.delete("\n").strip
        else
        @PDYJ = "/"
        end
        # 排出非合并项
        # @JYYJ = nil if (row[11].nil? and row.format(11).top != :none)

        # 检验依据
        unless row[12].nil?
        @JYYJ = row[12].to_s.delete("\n").strip
        else
        @JYYJ = "/"
        end

        # 排除非合并项
        # @PDYJ = nil if (row[12].nil? and row.format(12).top != :none)
	
        # 检验依据简化版
       unless row[13].nil?
	       @JYYJJHB = row[13].to_s.delete("\n").strip
	     else
        @JYYJJHB = "/"
       end

        # 标准方法检出限
        unless row[14].nil?
        @BZFFJCX = row[14].to_s.delete("\n").strip
        else
         @BZFFJCX ="/"
        end

        # 排出非合并项
        # @BZFFJCX = nil if (row[13].nil? and row.format(13).top != :none)

        # 标准方法检出限单位
        unless row[15].nil?
         @BZFFJCXDW = row[15].to_s.delete("\n").strip
        else
         @BZFFJCXDW ="/"
        end
       # 排出非合并项
        # @BZFFJCXDW = nil if (row[14].nil? and row.format(14).top != :none)

        # 标准最小允许限
        unless row[16].nil?
         @BZZXYXX = row[16].to_s.delete("\n").strip
        else
         @BZZXYXX ="/"
        end
        
       # 排出非合并项
        # @BZZXYXX = nil if (row[15].nil? and row.format(15).top != :none)

        # 标准最小允许限单位
        unless row[17].nil?
         @BZZXYXXDW = row[17].to_s.delete("\n").strip
        else
         @BZZXYXXDW = "/"
        end
        # 排出非合并项
        # @BZZXYXXDW = nil if (row[16].nil? and row.format(16).top != :none)

        # 标准最大允许限
        unless row[18].nil?
         @BZZDYXX = row[18].to_s.delete("\n").strip
        else
         @BZZDYXX ="/"
        end
        # 排出非合并项
        # @BZZDYXX = nil if (row[17].nil? and row.format(17).top != :none)

        # 标准最大允许限单位
        unless row[19].nil?
         @BZZDYXXDW = row[19].to_s.delete("\n").strip
       else
         @BZZDYXXDW = "/"
       end
       # 排出非合并项
        # @BZZDYXXDW = nil if (row[18].nil? and row.format(18).top != :none)
	
        # 备注
        unless row[25].nil?
          @BZ = row[25].to_s.delete("\n").strip
        else
          @BZ ="/"
        end

        @lines.push({A_category: @A_category, B_category: @B_category, C_category: @C_category, D_category: @D_category, JYXM: @JYXM, JGDW: @JGDW, PDYJ: @PDYJ, JYYJ: @JYYJ,JYYJJHB: @JYYJJHB, BZFFJCX: @BZFFJCX, BZFFJCXDW: @BZFFJCXDW, BZZXYXX: @BZZXYXX, BZZXYXXDW: @BZZXYXXDW, BZZDYXX: @BZZDYXX, BZZDYXXDW: @BZZDYXXDW,BZ: @BZ})
      end

      self.generate_identifier

      ActiveRecord::Base.transaction do
        CheckItem.where(identifier: self.identifier).update_all({JGDW: nil, JYYJ: nil, PDYJ: nil, BZFFJCX: nil, BZFFJCXDW: nil, BZZXYXX: nil, BZZXYXXDW: nil, BZZDYXX: nil, BZZDYXXDW: nil,BZ: nil,JYYJJHB: nil})

        category_ids = {
            a_category_ids: [],
            b_category_ids: [],
            c_category_ids: [],
            d_category_ids: [],
            item_ids: []
        }

        @lines.each do |line|
          a_category = ACategory.with_deleted.where(name: line[:A_category], identifier: self.identifier).first_or_create
          a_category.restore if a_category.deleted?
          category_ids[:a_category_ids].push(a_category.id)

          b_category = BCategory.with_deleted.where(name: line[:B_category], identifier: self.identifier, a_category_id: a_category.id).first_or_create
          b_category.restore if b_category.deleted?
          category_ids[:b_category_ids].push(b_category.id)

          c_category = CCategory.with_deleted.where(name: line[:C_category], identifier: self.identifier, a_category_id: a_category.id, b_category_id: b_category.id).first_or_create
          c_category.restore if c_category.deleted?
          category_ids[:c_category_ids].push(c_category.id)

          d_category = DCategory.with_deleted.where(name: line[:D_category], identifier: self.identifier, a_category_id: a_category.id, b_category_id: b_category.id, c_category_id: c_category.id).first_or_create
          d_category.restore if d_category.deleted?
          category_ids[:d_category_ids].push(d_category.id)

          item = CheckItem.with_deleted.where(identifier: self.identifier, a_category_id: a_category.id, b_category_id: b_category.id, c_category_id: c_category.id, d_category_id: d_category.id, name: line[:JYXM]).first_or_create
          item.restore if item.deleted?
         # item.JGDW = (item.JGDW || "").split("#").push(line[:JGDW]).uniq.join("#") unless line[:JGDW].blank?
          if line[:JGDW]=="/"
           item.JGDW = (item.JGDW || "").split("#").push("/").join("#")
          else
           item.JGDW = (item.JGDW || "").split("#").push(line[:JGDW]).uniq.join("#")
          end

         
         #item.JYYJ = (item.JYYJ || "").split("#").push(line[:JYYJ]).uniq.join("#") unless line[:JYYJ].blank?
          if line[:JYYJ]=="/"
             item.JYYJ = (item.JYYJ || "").split("#").push("/").join("#")
          else
            item.JYYJ = (item.JYYJ || "").split("#").push(line[:JYYJ]).join("#")
          end

          #item.PDYJ = (item.PDYJ || "").split("#").push(line[:PDYJ]).uniq.join("#") unless line[:PDYJ].blank?
          if line[:PDYJ] =="/"
            item.PDYJ = (item.PDYJ || "").split("#").push("/").join("#")
          else
            item.PDYJ = (item.PDYJ || "").split("#").push(line[:PDYJ]).uniq.join("#")
          end


         # item.BZFFJCX = (item.BZFFJCX || "").split("#").push(line[:BZFFJCX]).uniq.join("#") unless line[:BZFFJCX].blank?

         if line[:BZFFJCX] =="/"
          item.BZFFJCX = (item.BZFFJCX || "").split("#").push("/").join("#")
         else
          item.BZFFJCX = (item.BZFFJCX || "").split("#").push(line[:BZFFJCX]).join("#")
         end 

         # item.BZFFJCXDW = (item.BZFFJCXDW || "").split("#").push(line[:BZFFJCXDW]).uniq.join("#") unless line[:BZFFJCXDW].blank?
         if line[:BZFFJCXDW]=="/"
          item.BZFFJCXDW = (item.BZFFJCXDW || "").split("#").push("/").join("#")
         else
          item.BZFFJCXDW = (item.BZFFJCXDW || "").split("#").push(line[:BZFFJCXDW]).join("#")
         end 


         # item.BZZXYXX = (item.BZZXYXX || "").split("#").push(line[:BZZXYXX]).uniq.join("#") unless line[:BZZXYXX].blank?
         if line[:BZZXYXX]=="/"
            item.BZZXYXX = (item.BZZXYXX || "").split("#").push("/").join("#")
         else
            item.BZZXYXX = (item.BZZXYXX || "").split("#").push(line[:BZZXYXX]).join("#")
         end   
         # item.BZZXYXXDW = (item.BZZXYXXDW || "").split("#").push(line[:BZZXYXXDW]).uniq.join("#") unless line[:BZZXYXXDW].blank?
        if line[:BZZXYXXDW] =="/"
           item.BZZXYXXDW = (item.BZZXYXXDW || "").split("#").push("/").join("#")
        else
           item.BZZXYXXDW = (item.BZZXYXXDW || "").split("#").push(line[:BZZXYXXDW]).join("#")
        end


        #  item.BZZDYXX = (item.BZZDYXX || "").split("#").push(line[:BZZDYXX]).uniq.join("#") unless line[:BZZDYXX].blank?
        if line[:BZZDYXX] =="/"
           item.BZZDYXX = (item.BZZDYXX || "").split("#").push("/").join("#")
        else
           item.BZZDYXX = (item.BZZDYXX || "").split("#").push(line[:BZZDYXX]).join("#")
        end

         # item.BZZDYXXDW = (item.BZZDYXXDW || "").split("#").push(line[:BZZDYXXDW]).uniq.join("#") unless line[:BZZDYXXDW].blank?
        if line[:BZZDYXXDW] =="/"
           item.BZZDYXXDW = (item.BZZDYXXDW || "").split("#").push("/").join("#")
        else
           item.BZZDYXXDW = (item.BZZDYXXDW || "").split("#").push(line[:BZZDYXXDW]).join("#")
        end

         # item.JYYJJHB = (item.JYYJJHB || "").split("#").push(line[:JYYJJHB]).uniq.join("#") unless line[:JYYJJHB].blank?
         if line[:JYYJJHB] =="/"
          item.JYYJJHB = (item.JYYJJHB || "").split("#").push("/").join("#")
         else
          item.JYYJJHB = (item.JYYJJHB || "").split("#").push(line[:JYYJJHB]).join("#")
         end
	        #item.BZ= (item.BZ || "").split("#").push(line[:BZ]).join("#") unless line[:BZ].blank?
         if line[:BZ]=="/"
          item.BZ= (item.BZ || "").split("#").push("/").join("#")
         else
          item.BZ= (item.BZ || "").split("#").push(line[:BZ]).join("#")
         end
         item.save
          category_ids[:item_ids].push(item.id)

          ACategory.where('id NOT IN (?) AND identifier = ?', category_ids[:a_category_ids].uniq, self.identifier).destroy_all
          BCategory.where('id NOT IN (?) AND identifier = ?', category_ids[:b_category_ids].uniq, self.identifier).destroy_all
          CCategory.where('id NOT IN (?) AND identifier = ?', category_ids[:c_category_ids].uniq, self.identifier).destroy_all
          DCategory.where('id NOT IN (?) AND identifier = ?', category_ids[:d_category_ids].uniq, self.identifier).destroy_all
          CheckItem.where('id NOT IN (?) AND identifier = ?', category_ids[:item_ids].uniq, self.identifier).destroy_all

        end
      end
    end
  end

  def generate_identifier
    #self.identifier = "#{rand(1000000)}#{Time.now.to_i}#{rand(1000000)}".to_i.to_s(16)
    self.identifier = Digest::SHA1.hexdigest(self.baosong_a.name + self.name)
  end
end
