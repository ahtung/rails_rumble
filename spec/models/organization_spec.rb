require 'rails_helper'

RSpec.describe Organization, type: :model do
  # Relations
  it { should have_many(:repos).dependent(:destroy) }
  it { should have_many(:memberships).dependent(:destroy) }
  it { should have_many(:users).through(:memberships) }

  # Instance methods
  describe '#' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user) }

    describe 'next' do
    end

    describe 'previous' do
    end

    describe 'sync!' do
      it 'should queue a OrganizationSyncer' do
        organization.sync!(2014, user)
        expect(OrganizationSyncer).to have_enqueued_job(organization.id, 2014, user.id)
      end
    end

    describe 'fetch_repos!' do
      it 'should increase repo count'
    end

    describe 'employees_of_the_month(year)' do
      xit 'should return an array of length 12' do
        expect(organization.employees_of_the_year(2015).length).to eq(12)
      end
    end
  end
end
