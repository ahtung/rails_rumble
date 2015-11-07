require 'rails_helper'

RSpec.describe Organization, type: :model do
  # Relations
  it { should have_many(:repos).dependent(:destroy) }
  it { should have_many(:employees).through(:employees_organizations) }
  it { should have_many(:employees_organizations).dependent(:destroy) }

  # ActiveRecord
  # it { should have_db_index(:palette_id) }

  # Instance methods
  describe '#' do
    let(:organization) { create(:organization) }

    describe 'sync!' do
      it 'should queue a OrganizationSyncer' do
        organization.sync!(2014)
        expect(OrganizationSyncer).to have_enqueued_job(organization.id, 2014)
      end
    end

    describe 'fetch_repos!' do
      it 'should increase repo count' do
        organization.fetch_repos!
        expect(organization.repos.count).to eq(1)
      end
    end

    describe 'employees_of_the_month(year)' do
      it 'should return an array of length 12' do
        expect(organization.employees_of_the_year(2015).length).to eq(12)
      end
    end
  end
end
