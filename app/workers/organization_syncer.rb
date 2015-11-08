class OrganizationSyncer
  include Sidekiq::Worker

  sidekiq_options retry: false, unique: :until_and_while_executing, expires_in: 1.hour

  def perform(id, year, user_id)
    user = User.find(user_id)
    @organization = Organization.find(id)

    @organization.fetch_repos_as_user!(user) # REQ
    @organization.update(commits: {})
    @organization.set_commits

    @prog = 0
    for month in 1..12 do
      @organization.repos.each_with_index do |repo, repo_index|
        beginning_of_month = Date.new(year, month, 1).beginning_of_month
        end_of_month = Date.new(year, month, 1).end_of_month

        @organization.update_attributes(state: 'syncing') if repo_index == 0
        repo.fetch_contributors_as_user!(user)  # REQ
        new_message = { repo_count: @organization.repos.count, org_name: @organization.name }
        WebsocketRails[:sync].trigger('syncer.repos', new_message)

        commits = []
        @organization.users.map(&:login).each_with_index do |contributor, index|
          begin
            commits = user.client.commits("#{@organization.name}/#{repo.name}", author: contributor, since: beginning_of_month, until: end_of_month) # REQ
            commits.concat(user.client.last_response.rels[:next].get.data) while user.client.last_response.rels[:next] # REQ
          rescue
          ensure
            @prog += 1
            update_yearly_and_notify(year, month, contributor => commits.count)
            update_progress_and_notify
          end
        end
        @organization.update_attributes(state: 'completed') if repo_index == @organization.repos.count - 1
      end
    end
  end

  def update_yearly_and_notify(year, month, contributors_commits)
    puts 'update_yearly_and_notify'
    if @organization.commits[year][month][contributors_commits.keys.first]
      @organization.commits[year][month][contributors_commits.keys.first] += contributors_commits.values.first
    else
      @organization.commits[year][month][contributors_commits.keys.first] = contributors_commits.values.first
    end
    puts @organization.commits
    @organization.save
    max_member = @organization.commits[year][month].max_by { |k,v| v }
    best_index = @organization.users.map(&:login).index(max_member.first)
    new_message = { pos: best_index, month: month, org_name: @organization.name }
    WebsocketRails[:sync].trigger('syncer.yearly', new_message)
  end

  def update_progress_and_notify
    total_prog = 12 * @organization.users.count * @organization.repos.count
    progress = (@prog.to_f / total_prog.to_f * 100.0).to_i
    message = { prog: progress, org_name: @organization.name }
    WebsocketRails[:sync].trigger('syncer.progress', message)
  end
end
