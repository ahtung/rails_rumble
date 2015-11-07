require 'rails_helper'

RSpec.describe Organization, type: :model do
  # Relations
  it { should have_many(:repos).dependent(:destroy) }
  it { should have_many(:employees).through(:employees_organizations) }
  it { should have_many(:employees_organizations).dependent(:destroy) }

  # ActiveRecord
  # it { should have_db_index(:palette_id) }

  # Instance methods
  describe "#" do
    describe "next" do
    end

    describe "previous" do
    end
  end
end
