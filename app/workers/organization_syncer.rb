class OrganizationSyncer
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(id, year, user_id)
    user = User.find(user_id)
    organization = Organization.find(id)
    organization.fetch_repos_as_user!(user)

    for month in 1..12 do
      beginning_of_month = Date.new(year, month, 1).beginning_of_month
      end_of_month = Date.new(year, month, 1).end_of_month

      organization.repos.each do |repo|
        organization_members = {}
        contributors = repo.contributors
        next if contributors.blank?
        contributor_names = contributors.map(&:name)
        contributor_names.each do |contributor|
          puts "#{organization.name}/#{repo.name}"
          # begin
          #   commits = client.commits(
          #     "#{organization.name}/#{repo.name}",
          #     author: contributor,
          #     since: beginning_of_month,
          #     until: end_of_month,
          #     per_page: 100
          #   )
          #   while client.last_response.rels[:next]
          #     commits.concat client.last_response.rels[:next].get.data
          #   end
          #   if scores[year][month][member]
          #     scores[year][month][member] += commits.count
          #   else
          #     scores[year][month].merge!(member => commits.count)
          #   end
          # rescue
          # end
        end
      end
    end

  end
end
