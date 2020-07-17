require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Subscription, type: :model do
  subject { create :subscription }

  it 'should has the initialized state' do
    expect(subject).to be_initialized
  end

  it 'should save the states changes' do
    expect do
      subject.activate!
    end.to change {
      maps_from_to(subject.reload.status_changes)
    }
      .from([])
      .to([{ from: 'initialized', to: 'active' }])
  end

  context 'when there is already some state stored' do
    before do
      subject.activate!
    end

    it 'should append states changes' do
      expect do
        subject.reload.suspend!
      end.to change {
        maps_from_to(subject.reload.status_changes)
      }
        .from([{ from: 'initialized', to: 'active' }])
        .to([{ from: 'initialized', to: 'active' }, { from: 'active', to: 'suspended' }])
    end
  end

  context 'when tries to go to an invalid state' do
    before do
      subject.activate!
    end

    it 'should save the attempts' do
      expect do
        subject.initialize_again!
      end.to change {
        maps_from_to(subject.reload.status_changes_attempts)
      }
        .from([{ from: 'initialized', to: 'activate!' }])
        .to([{ from: 'initialized', to: 'activate!' }, { from: 'active', to: 'initialize_again!' }])

      expect(maps_from_to(subject.reload.status_changes)).to eql([{ from: 'initialized', to: 'active' }])
    end
  end

  private

  def maps_from_to(map_object)
    map_object.map { |e| { from: e[:from], to: e[:to] } }
  end
end
# rubocop:enable Metrics/BlockLength
