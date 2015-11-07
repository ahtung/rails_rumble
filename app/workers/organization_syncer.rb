class OrganizationSyncer
  include Sidekiq::Worker

  def perform(id)
    puts 'YEY'
  end
end
