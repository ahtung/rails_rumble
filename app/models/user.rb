class User < ActiveRecord::Base
  has_many :memberships
  has_many :organizations, through: :memberships

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  def self.from_omniauth(auth)
    signed_user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
    signed_user.fetch_organizations!
    signed_user
  end

  def fetch_organizations!
    organizations.create(name: 'First Organization')
  end
end
