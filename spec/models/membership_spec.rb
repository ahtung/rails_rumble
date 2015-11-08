require 'rails_helper'

RSpec.describe Membership, type: :model do
  # Relations
  it { should belong_to(:organization) }
  it { should belong_to(:user) }

  # ActiveRecord
  it { should have_db_index(:organization_id) }
  it { should have_db_index(:user_id) }
end
