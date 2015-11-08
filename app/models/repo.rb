class Repo < ActiveRecord::Base
  # Relations
  belongs_to :organization
  has_many :repos_users, dependent: :destroy
  has_many :users, through: :repos_users

  def fetch_contributors_as_user!(user)
    contributors = client(user).contributors("#{organization.name}/#{name}")
    contributors.concat client(user).last_response.rels[:next].get.data while client(user).last_response.rels[:next]
    return if contributors == ''
    users.delete_all
    contributors.each do |contributor|
      user = User.from_login(contributor)
      users << user unless users.include?(user)
    end
  end

  private

  def client(user)
    @client ||= user.client
  end
end
