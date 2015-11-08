class User < ActiveRecord::Base
  # Relations
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :repos_users, dependent: :destroy
  has_many :repos, through: :repos_users

  devise :omniauthable

  validates :email, presence: false, email: false

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.login = auth.info.nickname
      user.avatar_url = auth.info.image
      user.password = Devise.friendly_token[0,20]
    end
  end

  def self.from_contributor(contributor)
    User.where(login: contributor.login).first_or_create do |user|
      user.provider = 'github'
      user.uid = contributor.id
      user.password = Devise.friendly_token[0,20]
      user.avatar_url = contributor.avatar_url
    end
  end

  def fetch_organizations!
    user = client.user
    orgs = user.rels[:organizations].get.data
    while client.last_response.rels[:next]
      orgs.concat client.last_response.rels[:next].get.data
    end
    orgs.each do |org|
      org_data = client.organization(org.login)
      new_org = organizations.where(name: org.login).first_or_create
      new_org.update(est_at: org_data.created_at)
      new_org.fetch_members_for!(org, client)
    end
  end

  def client
    return if oauth_token.nil?
    @client ||= Octokit::Client.new(access_token: oauth_token)
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
