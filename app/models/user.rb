class User < ActiveRecord::Base
  has_many :memberships
  has_many :organizations, through: :memberships

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def fetch_organizations!
    user = client.user
    user.login
    orgs = user.rels[:organizations].get.data
    organization_names = orgs.map { |org| { name: org.login } }
    organizations.create(organization_names)
  end

  private

  def client
    return if oauth_token.nil?
    @client ||= Octokit::Client.new(access_token: oauth_token)
  end
end
