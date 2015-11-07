class Organization < ActiveRecord::Base
  def sync!
    OrganizationSyncer.perform_async(id)
  end

  def employees_of_the_year(year)
    [
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
    ]
  end
end
