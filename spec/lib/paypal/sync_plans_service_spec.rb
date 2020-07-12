require 'rails_helper'

describe Paypal::SyncPlansService, vcr: {
  cassette_name: 'paypal/plans',
  record: :once
} do

  before do
    described_class.new.sync
  end

  subject do
    PaypalPlan.find_by(description: 'regular_class_1_private_lessons_1_with_1_weekly_experience')
  end

  it 'should have right attributes' do
    expect(subject.name).to eql('Plano mensal com 1 aula regular semanal, 1 aula particular e 1 semana de olhadinha')
    expect(subject.regular_price).to eql(190)
    expect(subject.week_experience_price).to eql(40)
  end

  it 'should have some paypal_plans, with some regular_price' do
    expect(PaypalPlan.count).to be > 0
    expect(PaypalPlan.all.map(&:regular_price)).not_to include(nil)
  end
end
