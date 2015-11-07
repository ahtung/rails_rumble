module ApplicationHelper
  def get_years(date)
    return [2015] if date.nil?
    # date = Time.local(date)
    year_first = date.strftime("%Y").to_i
    year_now = Time.now.strftime("%Y").to_i
    [*year_first..year_now]
  end
end
