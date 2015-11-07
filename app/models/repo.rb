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
    contributors.each do |contributor|
      users.where(login: contributor.login).first_or_create
    end
  end
end
