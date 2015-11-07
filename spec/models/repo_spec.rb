require 'rails_helper'

RSpec.describe Repo, type: :model do
  # Relations
  it { should belong_to(:organization) }
  it { should have_many(:users_repos).dependent(:destroy) }
  it { should have_many(:users).through(:users_repos) }

  # ActiveRecord
  it { should have_db_index(:organization_id) }
end
