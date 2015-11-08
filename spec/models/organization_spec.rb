require 'rails_helper'

RSpec.describe Organization, type: :model do
  # Relations
  it { should have_many(:repos).dependent(:destroy) }
  it { should have_many(:memberships).dependent(:destroy) }
  it { should have_many(:users).through(:memberships) }

  # Instance methods
  describe '#', skip: true do
    let(:organization) { create(:organization) }
    let(:user) { create(:user) }

    describe 'next' do
      it 'should return next org of user' do
        organizations = create_list(:organization, 3)
        middle = organizations[1]
        expect(middle.next).not_to eq(nil)
      end

      it 'should not return next org if none' do
        expect(organization.next).to eq(nil)
      end
    end

    describe 'previous', skip: true do
      it 'should return previous org of user' do
        organizations = create_list(:organization, 3)
        middle = organizations[1]
        expect(middle.previous).not_to eq(nil)
      end

      it 'should not return previous org if none' do
        expect(organization.previous).to eq(nil)
      end
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
