require 'rails_helper'

RSpec.describe User, type: :model do
  # Relations
  it { should have_many(:memberships).dependent(:destroy) }
  it { should have_many(:organizations).through(:memberships) }
  it { should have_many(:repos_users).dependent(:destroy) }
  it { should have_many(:repos).through(:repos_users) }

  describe '#' do
    let(:user) { create(:user) }

    it 'email_required? should return false' do
      expect(user.email_required?).to be(false)
    end

    it 'email_changed? should return false' do
      expect(user.email_changed?).to be(false)
    end
  end
end
