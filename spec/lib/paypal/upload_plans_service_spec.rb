# rubocop:disable Metrics/BlockLength
require 'rails_helper'

describe Paypal::UploadPlansService, vcr: {
  cassette_name: 'paypal/upload_plans',
  record: :once
} do
  before do
    private_plan_price
    regular_plan_price
    week_experience_plan_price
  end

  let!(:private_plan_price) do
    create(
      :plan_price,
      kind: 'private_lessons',
      prices: private_prices
    )
  end

  let!(:regular_plan_price) do
    create(
      :plan_price,
      kind: 'regular_classes',
      prices: regular_prices
    )
  end

  let!(:week_experience_plan_price) do
    create(
      :plan_price,
      kind: 'week_experience',
      prices: week_experience_prices
    )
  end

  let(:private_prices) do
    [
      { count: 1, price: 90 },
      { count: 2, price: 165 },
      { count: 3, price: 240 },
      { count: 4, price: 285 },
      { count: 5, price: 355 },
      { count: 6, price: 425 },
      { count: 7, price: 495 },
      { count: 8, price: 560 },
      { count: 9, price: 625 },
      { count: 10, price: 690 },
      { count: 11, price: 755 },
      { count: 12, price: 820 }
    ]
  end

  let(:regular_prices) do
    [
      { count: 1, price: 100 },
      { count: 2, price: 165 },
      { count: 3, price: 235 },
      { count: 4, price: 300 },
      { count: 5, price: 390 },
      { count: 6, price: 450 },
      { count: 7, price: 545 }
    ]
  end

  let(:week_experience_prices) do
    [{ price: 40 }]
  end

  let(:expected) do
    {
      regular_classes_per_week: 5,
      private_lessons_per_month: 12,
      week_experience: false,
      regular_price: 1210,
      week_experience_price: 0,
      name: '5 aulas regulares por semana, mais 12 aulas partculares por mês',
      description: 'regular_class_5_private_lessons_5_with_0_weekly_experience'
    }
  end

  subject do
    described_class.new.upload
  end

  it 'should not raise error' do
    expect { subject }.not_to raise_error
  end
end
# rubocop:enable Metrics/BlockLength
