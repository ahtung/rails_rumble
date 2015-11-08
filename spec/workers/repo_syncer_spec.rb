require 'spec_helper'

RSpec.describe RepoSyncer do
  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable false }
  xit { is_expected.to be_unique :until_and_while_executing }
  xit { is_expected.to be_expired_in 1.hour }

  xit 'enqueues another repo syncer' do
    user = create(:user)
    org = create(:organization)

    subject.perform(org.id, 2015, user.id)

    expect(OrganizationSyncer).to have_enqueued_job(org.id, 2015, user.id)
  end
end
