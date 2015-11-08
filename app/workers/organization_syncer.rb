class OrganizationSyncer
  include Sidekiq::Worker

  sidekiq_options retry: false, unique: :until_and_while_executing, expires_in: 1.hour

  def perform(id, year, user_id)
    yearly = {
      year => {
        1  => {},
        2  => {},
        3  => {},
        4  => {},
        5  => {},
        6  => {},
        7  => {},
        8  => {},
        9  => {},
        10 => {},
        11 => {},
        12 => {}
      }
    }
    user = User.find(user_id)
    organization = Organization.find(id)
    organization.fetch_repos_as_user!(user)
    total_prog = 12 * organization.users.count * organization.repos.count
    organization.update_attributes(state: 'syncing', commits: yearly)

    prog = 0
    for month in 1..12 do
      beginning_of_month = Date.new(year, month, 1).beginning_of_month
      end_of_month = Date.new(year, month, 1).end_of_month

      organization.repos.each_with_index do |repo, repo_index|
        RepoSyncer.perform_async(repo, user.id, year, month)
      end
      organization.update_attributes(commits: yearly)
    end
    organization.update_attributes(state: 'completed')
  end
end
