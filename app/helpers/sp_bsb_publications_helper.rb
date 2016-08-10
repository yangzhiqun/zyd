module SpBsbPublicationsHelper
  def checkbox_enable?(record, tab)
    if tab == 0
      return !PublishedSpBsb.exists?(cjbh: record.sp_s_16)
    elsif tab == 1
      return (PublishedSpBsb.exists?(cjbh: record.cjbh) and !PublishedWtypCzb.exists?(cjbh: record.cjbh, wtyp_czb_type: record.wtyp_czb_type))
    end
  end
end
