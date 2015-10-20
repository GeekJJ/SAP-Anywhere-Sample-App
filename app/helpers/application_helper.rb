module ApplicationHelper
  def api_key
    ENV['API_KEY']
  end

  def api_secret
    ENV['API_SECRET']
  end

  def install_scope
    "AdminFunction_R,AdminFunction_RW,BusinessData_R,BusinessData_RW"
  end
end
