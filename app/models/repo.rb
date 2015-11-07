class Repo < ActiveRecord::Base
  # Relations
  belongs_to :organization
  has_many :repos_users, dependent: :destroy
  has_many :users, through: :repos_users

  def fetch_contributors_as_user!(user)
    client = user.client
    contributors = client.contributors("#{organization.name}/#{name}")
    while client.last_response.rels[:next]
      contributors.concat client.last_response.rels[:next].get.data
    end
    return if contributors == ''
    users.delete_all
    contributors.each do |contributor|
      puts contributor.login
      user = User.where(login: contributor.login).first_or_create do |user|
        user.provider = 'github'
        user.uid = contributor.id
        user.password = Devise.friendly_token[0,20]
      end
      users << user unless users.include?(user)
    end
  end
end
