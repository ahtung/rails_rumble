class RepoSyncer
  include Sidekiq::Worker

  sidekiq_options retry: false, unique: :until_and_while_executing

  def perform(repo_id, user_id, year, month, repo_index, total_prog)
    user = User.find(user_id)
    repo = Repo.find(repo_id)
    organization = repo.organization
    beginning_of_month = Date.new(year, month, 1).beginning_of_month
    end_of_month = Date.new(year, month, 1).end_of_month

    repo.fetch_contributors_as_user!(user)
    
    contributor_names = organization.users.map(&:login)
    contributor_names.each_with_index do |contributor, index|
      begin
        commits = user.client.commits("#{organization.name}/#{repo.name}", author: contributor, since: beginning_of_month, until: end_of_month)
        commits.concat(user.client.last_response.rels[:next].get.data) while user.client.last_response.rels[:next]
      rescue
      ensure
        update_yearly
        update_progress
      end
    end
  end

  def update_yearly
    puts 'update_yearly'
    # new_message = { pos: best_index, prog: progress, month: month, member: max_member, org_name: organization.name }
    # WebsocketRails[:sync].trigger('syncer', new_message)
  end

  def update_progress
    puts 'update_progress'
    # progress = (index.to_f / total_prog.to_f * 100.0).to_i
    # max_member = organization.commits[year][month].max_by { |k,v| v }
    # best_index = contributor_names.index(max_member.first)
    # puts "#{prog} - #{best_index}"
    # new_message = { pos: best_index, prog: progress, month: month, member: max_member, org_name: organization.name }
    # WebsocketRails[:sync].trigger('syncer', new_message)
  end
end
