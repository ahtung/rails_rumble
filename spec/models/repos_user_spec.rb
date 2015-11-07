require 'rails_helper'

RSpec.describe ReposUser, type: :model do
  # Relations
  it { should belong_to(:repo) }
  it { should belong_to(:user) }

  # ActiveRecord
  it { should have_db_index(:repo_id) }
  it { should have_db_index(:user_id) }
end
