require 'rails_helper'

RSpec.describe User, type: :model do
  # Relations
  it { should have_many(:organizations_users).dependent(:destroy) }
  it { should have_many(:organizations).through(:organizations_users) }
  it { should have_many(:users_repos).dependent(:destroy) }
  it { should have_many(:repos).through(:users_repos) }
end
