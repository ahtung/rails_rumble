require 'rails_helper'

RSpec.describe User, type: :model do
  # Relations
  it { should have_many(:memberships).dependent(:destroy) }
  it { should have_many(:organizations).through(:memberships) }
  it { should have_many(:repos_users).dependent(:destroy) }
  it { should have_many(:repos).through(:repos_users) }
end
