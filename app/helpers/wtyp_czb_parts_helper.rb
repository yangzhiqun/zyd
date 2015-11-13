module WtypCzbPartsHelper
  def is_fill_enabled?(czb)
		if czb.current_state == ::WtypCzb::State::ASSIGNED
			return current_user.id == czb.czfzr.to_i && current_user.hcz_admin == 0 && current_user.hcz_czbl == 1
		else
			false
		end
  end
end
