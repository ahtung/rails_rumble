require 'rails_helper'

RSpec.describe Repo, type: :model do
  # Relations
  xit { should belong_to(:organization) }
  xit { should have_many(:users_repos).dependent(:destroy) }
  xit { should have_many(:users).through(:users_repos) }

  # ActiveRecord
  xit { should have_db_index(:organization_id) }
end
