class OrganizationSyncer
  include Sidekiq::Worker

  def perform
    puts 'YEY'
  end
end
