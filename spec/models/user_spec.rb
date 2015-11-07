require 'rails_helper'

RSpec.describe User, type: :model do
  # Relations
  xit { should have_many(:organizations_users).dependent(:destroy) }
  xit { should have_many(:organizations).through(:organizations_users) }
  xit { should have_many(:users_repos).dependent(:destroy) }
  xit { should have_many(:repos).through(:users_repos) }
end
