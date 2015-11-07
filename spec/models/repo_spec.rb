require 'rails_helper'

RSpec.describe Repo, type: :model do
  # Relations
  it { should belong_to(:organization) }
  it { should have_many(:repos_users).dependent(:destroy) }
  it { should have_many(:users).through(:repos_users) }

  # ActiveRecord
  xit { should have_db_index(:organization_id) }
end
