class OrganizationSyncer
  include Sidekiq::Worker
  sidekiq_options retry: false, unique: true, expires_in: 1.hour

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

    for month in 1..12 do
      beginning_of_month = Date.new(year, month, 1).beginning_of_month
      end_of_month = Date.new(year, month, 1).end_of_month

      organization.repos.each do |repo|
        repo.fetch_contributors_as_user!(user)
        next if repo.users.blank?
        contributor_names = repo.users.map(&:login)
        contributor_names.each do |contributor|
          puts "#{organization.name}/#{repo.name}"
          # begin
            commits = user.client.commits(
              "#{organization.name}/#{repo.name}",
              author: contributor,
              since: beginning_of_month,
              until: end_of_month,
              per_page: 100
            )
            while user.client.last_response.rels[:next]
              commits.concat user.client.last_response.rels[:next].get.data
            end

            if yearly[year][month][contributor]
              yearly[year][month][contributor] += commits.count
            else
              yearly[year][month].merge!(contributor => commits.count)
            end
            puts yearly.inspect
          # rescue
          # end
        end
      end
      organization.update_attribute(:commits, yearly)
    end
  end
end
