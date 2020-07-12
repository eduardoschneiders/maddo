require 'rails_helper'

describe PlanBuilder do
  subject do
    described_class.new(
      regular_class_count: regular_class_count
      private_lessons_count: private_lessons_count
      week_trial: week_trial
    ).build
  end



  let!(one_private_lessons_paypal_plan) do
    create(:paypal_plan,
      name: 'Plano mensal com 1 aula particular',
      description: 'regular_class_0_private_lessons_1_with_0_weekly_experience'
      external_id: 'P-01280341RK877531GL4FDAXI'
    )
  end

  let!(one_regular_lessons_paypal_plan) do
    create(:paypal_plan,
      name: 'Plano mensal com 1 aula regular',
      description: 'regular_class_1_private_lessons_0_with_0_weekly_experience'
      external_id: 'P-273045463V5596003L4BWRKQ'
    )
  end

  let!(one_regular_lessons_paypal_plan_with_one_weekly_experience) do
    create(:paypal_plan,
      name: 'Plano mensal com 1 aula regular',
      description: 'regular_class_1_private_lessons_0_with_1_weekly_experience'
      external_id: 'P-273045463V5596003L4BWRKQ'
    )
  end


  # let(:regular_class_count) { 0 }
  # let(:private_lessons_count) { 0 }
  # let(:week_trial) { false }



  context 'when combination is valid' do
    context 'when select one regular' do
      context 'when select with weekly experience' do
        it_should_behave_like 'there is a plan builed'
      end
    end

    context 'when select one private lesson' do
    end
  end

  context 'when combination is not valid' do
    context 'with no option selected' do

    end

    context 'when invalid combination' do
    end
  end


  it do
    expect(true).to eql(true)
  end
end
