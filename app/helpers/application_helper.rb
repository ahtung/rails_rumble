module ApplicationHelper
  def get_years(date)
    years = []
    date = Time.local(date)
    year_first = date.strftime("%Y").to_i
    year_now = Time.now.strftime("%Y").to_i
    (year_first..year_now).each do |year|
      years << year
    end
    return years
  end
end
