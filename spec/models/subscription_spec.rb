require 'rails_helper'

RSpec.describe Subscription, type: :model do
  subject { create :subscription }

  it 'should has the initialized state' do
    expect(subject).to be_initialized
  end

  it 'should save the states changes' do
    expect { subject.activate! }.to change { subject.reload.status_changes }
      .from([])
      .to([{ from: :initialized, to: :active }])
  end

  context 'when there is already some state stored' do
    before { subject.activate! }

    it 'should append states changes' do
      expect { subject.reload.suspend! }.to change { subject.reload.status_changes }
        .from([{ from: :initialized, to: :active }])
        .to([{ from: :initialized, to: :active }, { from: :active, to: :suspended }])
    end
  end
end
