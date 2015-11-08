class RepoSyncer
  include Sidekiq::Worker

  sidekiq_options retry: false, unique: :until_and_while_executing

  def perform(id, user_id, year, month, repo_index)
    user = User.find(user_id)
    @repo = Repo.find(id)
    @organization = @repo.organization
    beginning_of_month = Date.new(year, month, 1).beginning_of_month
    end_of_month = Date.new(year, month, 1).end_of_month

    if repo_index == 0
      @organization.update_attributes(state: 'syncing')
    end

    @repo.fetch_contributors_as_user!(user)  # REQ

    commits = []
    @organization.users.map(&:login).each_with_index do |contributor, index|
      begin
        commits = user.client.commits("#{@organization.name}/#{@repo.name}", author: contributor, since: beginning_of_month, until: end_of_month) # REQ
        commits.concat(user.client.last_response.rels[:next].get.data) while user.client.last_response.rels[:next] # REQ
      rescue
      ensure
        update_yearly_and_notify(year, month, contributor => commits.count)
        update_progress_and_notify(repo_index)
      end
    end

    if repo_index == @organization.repos.count - 1
      @organization.update_attributes(state: 'completed')
    end
  end

  def update_yearly_and_notify(year, month, contributors_commits)
    if @organization.commits[year][month][contributors_commits.keys.first]
      @organization.commits[year][month][contributors_commits.keys.first] += contributors_commits.values.first
    else
      @organization.commits[year][month][contributors_commits.keys.first] = contributors_commits.values.first
    end
    @organization.save
    max_member = @organization.commits[year][month].max_by { |k,v| v }
    best_index = @organization.users.map(&:login).index(max_member.first)
    new_message = { pos: best_index, month: month, org_name: @organization.name }
    WebsocketRails[:sync].trigger('syncer.yearly', new_message)
  end

  def update_progress_and_notify(index)
    total_prog = 12 * @organization.users.count * @organization.repos.count
    progress = (index.to_f / total_prog.to_f * 100.0).to_i
    message = { prog: progress, org_name: @organization.name }
    WebsocketRails[:sync].trigger('syncer.progress', message)
  end
end
