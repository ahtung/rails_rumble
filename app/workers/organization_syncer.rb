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
        repo.fetch_contributors_as_user!(user)
        next if repo.users.blank?
        contributor_names = repo.users.map(&:login)
        contributor_names.each_with_index do |contributor, index|
          begin
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
          rescue
          end

          prog += 1

          puts "#{month} #{index + 1} #{repo_index + 1}"
          progress = (prog.to_f / total_prog.to_f * 100.0).to_i
          puts "#{prog}"
          new_message = { prog: progress, month: month, member: yearly[year][month].max_by{|k,v| v}, org_name: organization.name }
          WebsocketRails[:sync].trigger('syncer', new_message)
        end
      end
      organization.update_attributes(commits: yearly)
    end
    organization.update_attributes(state: 'completed')
  end
end
