module ApplicationHelper
  def get_years(date = nil)
    return [2015] if date.nil?
    year_first = date.strftime("%Y").to_i
    year_now = Time.now.strftime("%Y").to_i
    [*year_first..year_now]
  end

  def sync_in_progress
    @organization.state == 'syncing'
  end
end
