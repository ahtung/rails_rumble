class OrganizationPolicy
  attr_reader :user, :organization

  def initialize(user, organization)
    @user = user
    @organization = organization
  end

  def index?
    user
  end

  def show?
    user.organizations.include?(organization)
  end

  def sync?
    user.organizations.include?(organization)
  end
end
