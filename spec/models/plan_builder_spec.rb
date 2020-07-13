require 'rails_helper'

describe PlanBuilder do
  subject do
    described_class.new(
      regular_classes_per_week: regular_classes_per_week,
      private_lessons_per_month: private_lessons_per_month,
      week_experience: week_experience
    ).build
  end

  let!(:one_private_lessons_paypal_plan) do
    create(:paypal_plan,
      name: 'Plano mensal com 1 aula particular',
      description: 'regular_class_0_private_lessons_1_with_0_weekly_experience',
      external_id: 'P-01280341RK877531GL4FDAXI',
      regular_price: 100,
      week_experience_price: nil
    )
  end

  let!(:one_regular_lessons_paypal_plan) do
    create(:paypal_plan,
      name: 'Plano mensal com 1 aula regular',
      description: 'regular_class_1_private_lessons_0_with_0_weekly_experience',
      external_id: 'P-273045463V5596003L4BWRKQ',
      regular_price: 90,
      week_experience_price: nil
    )
  end

  let!(:one_regular_lessons_and_one_private_paypal_plan) do
    create(:paypal_plan,
      name: 'Plano mensal com 1 aula regular e 1 aula particular',
      description: 'regular_class_1_private_lessons_1_with_0_weekly_experience',
      external_id: 'P-KJHADKJFHKJAHKHFHSAKJFFH',
      regular_price: 190,
      week_experience_price: nil
    )
  end

  let!(:one_regular_lessons_paypal_plan_with_one_weekly_experience) do
    create(:paypal_plan,
      name: 'Plano mensal com 1 aula regular e uma semana de olhadinha',
      description: 'regular_class_1_private_lessons_0_with_1_weekly_experience',
      external_id: 'P-ADS1KJ2KH234HK2JH342K34H',
      regular_price: 90,
      week_experience_price: 40
    )
  end

  let!(:one_private_lesson_one_regular_lessons_paypal_plan_with_one_weekly_experience) do
    create(:paypal_plan,
      name: 'Plano mensal com 1 aula particular, 1 aula regular e uma semana de olhadinha',
      description: 'regular_class_1_private_lessons_1_with_1_weekly_experience',
      external_id: 'P-JSADHDFAKJSDFHKKJJDRK34H',
      regular_price: 190,
      week_experience_price: 40
    )
  end

  shared_examples 'raise error' do
    it 'should raise error' do
      expect{ subject }.to raise_error Errors::PlanBuilderErrors::PaypalPlanNotFound
    end
  end

  context 'when nothing is selected' do
    let(:regular_classes_per_week) { 0 }
    let(:private_lessons_per_month) { 0 }
    let(:week_experience) { false }

    it_should_behave_like 'raise error'

    context 'when select just week experience' do
      let(:week_experience) { false }

      it_should_behave_like 'raise error'
    end

    context 'when select an invalid count' do
      let(:private_lessons_per_month) { 20 }

      it_should_behave_like 'raise error'
    end

    context 'when select one regular' do
      let(:regular_classes_per_week) { 1 }

      it 'should build a plan with success' do
        expect(subject.name).to eql('Plano mensal com 1 aula regular')
        expect(subject.regular_price).to eql(90)
        expect(subject.week_experience_price).to eql(nil)
        expect(subject.regular_classes_per_week).to eql(1)
        expect(subject.private_lessons_per_month).to eql(0)
        expect(subject.paypal_plan).to eql(one_regular_lessons_paypal_plan)
      end

      context 'when select with weekly experience' do
        let(:week_experience) { true }

        it 'should build a plan with success' do
          expect(subject.name).to eql('Plano mensal com 1 aula regular e uma semana de olhadinha')
          expect(subject.regular_price).to eql(90)
          expect(subject.week_experience_price).to eql(40)
          expect(subject.regular_classes_per_week).to eql(1)
          expect(subject.private_lessons_per_month).to eql(0)
          expect(subject.paypal_plan).to eql(one_regular_lessons_paypal_plan_with_one_weekly_experience)
        end
      end
    end

    context 'when select one private lesson' do
      let(:private_lessons_per_month) { 1 }

      it 'should build a plan with success' do
        expect(subject.name).to eql('Plano mensal com 1 aula particular')
        expect(subject.regular_price).to eql(100)
        expect(subject.week_experience_price).to eql(nil)
        expect(subject.regular_classes_per_week).to eql(0)
        expect(subject.private_lessons_per_month).to eql(1)
        expect(subject.paypal_plan).to eql(one_private_lessons_paypal_plan)
      end
    end

    context 'when select one regular and one private lesson' do
      let(:private_lessons_per_month) { 1 }
      let(:regular_classes_per_week) { 1 }

      it 'should build a plan with success' do
        expect(subject.name).to eql('Plano mensal com 1 aula regular e 1 aula particular')
        expect(subject.regular_price).to eql(190)
        expect(subject.week_experience_price).to eql(nil)
        expect(subject.regular_classes_per_week).to eql(1)
        expect(subject.private_lessons_per_month).to eql(1)
        expect(subject.paypal_plan).to eql(one_regular_lessons_and_one_private_paypal_plan)
      end
    end

    context 'when select one regular, one private lesson and with week experience' do
      let(:private_lessons_per_month) { 1 }
      let(:regular_classes_per_week) { 1 }
      let(:week_experience) { true }

      it 'should build a plan with success' do
        expect(subject.name).to eql('Plano mensal com 1 aula particular, 1 aula regular e uma semana de olhadinha')
        expect(subject.regular_price).to eql(190)
        expect(subject.week_experience_price).to eql(40)
        expect(subject.regular_classes_per_week).to eql(1)
        expect(subject.private_lessons_per_month).to eql(1)
        expect(subject.paypal_plan).to eql(one_private_lesson_one_regular_lessons_paypal_plan_with_one_weekly_experience)
      end

    end
  end
end
