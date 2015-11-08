require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#' do
    describe 'sync_in_progress' do
      it 'returns false if org.state != syncing' do
        org = create(:organization)
        controller.instance_variable_set(:@organization, org)
        expect(helper.sync_in_progress).to be(false)
      end

      it 'returns true if org.state == syncing' do
        org = create(:organization, state: 'syncing')
        controller.instance_variable_set(:@organization, org)
        expect(helper.sync_in_progress).to be(true)
      end
    end

    describe 'get_years' do
      it 'returns 2015 if nil' do
        expect(helper.get_years).to match_array([2015])
      end

      it "returns [2014 2015] if '2013-04-23T19:20:49Z'" do
        expect(helper.get_years(Time.new('2013-04-23T19:20:49Z'))).
          to match_array([2013, 2014, 2015])
      end
    end
  end
end
