require 'rails_helper'

RSpec.describe Membership, type: :model do
  # Relations
  it { should belong_to(:organization) }
  it { should belong_to(:user) }

  # ActiveRecord
  xit { should have_db_index(:organization_id) }
  xit { should have_db_index(:user_id) }
end
