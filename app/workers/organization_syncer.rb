class OrganizationSyncer
  include Sidekiq::Worker

  sidekiq_options retry: false, unique: :until_and_while_executing, expires_in: 1.hour

  def perform(id, year, user_id)
    user = User.find(user_id)
    organization = Organization.find(id)
    organization.fetch_repos_as_user!(user) # REQ
    total_prog = 12 * organization.users.count * organization.repos.count

    for month in 1..12 do
      organization.repos.each_with_index do |repo, repo_index|
        RepoSyncer.perform_async(repo.id, user.id, year, month, repo_index, total_prog)
      end
    end
  end
end
