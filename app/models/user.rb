class User < ActiveRecord::Base
  # Relations
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :repos_users, dependent: :destroy
  has_many :repos, through: :repos_users

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable

  validates :email, presence: false, email: false

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.login = auth.info.nickname
      user.password = Devise.friendly_token[0,20]
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
      organizations.where(name: org.login).first_or_create.update(est_at: org_data.created_at)
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
