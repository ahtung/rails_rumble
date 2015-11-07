class Organization < ActiveRecord::Base
  def sync!
    OrganizationSyncer.perform_async(id)
  end
end
