# rubocop:disable Metrics/MethodLength, Layout/LineLength, Metrics/AbcSize
module Paypal
  class PlanCombinationsBuilder
    def build
      private_combinations
        .concat(regular_combinations)
        .concat(private_and_regular_combinations)
        .concat(weekly_combination)
        .flatten
    end

    private

    def private_combinations
      private_plan_price.prices.map do |private_price|
        [
          {
            regular_classes_per_week: 0,
            private_lessons_per_month: private_price[:count],
            week_experience: false,
            regular_price: private_price[:price],
            week_experience_price: 0,
            name: "#{private_price[:count]} #{'aula'.pluralize(private_price[:count], :'pt-BR')} #{'particular'.pluralize(private_price[:count], :'pt-BR')} por mês.",
            description: "regular_class_0_private_lessons_#{private_price[:count]}_with_0_weekly_experience"
          }
        ]
      end
    end

    def regular_combinations
      regular_plan_price.prices.map do |regular_price|
        [
          {
            regular_classes_per_week: regular_price[:count],
            private_lessons_per_month: 0,
            week_experience: false,
            regular_price: regular_price[:price],
            week_experience_price: 0,
            name: "#{regular_price[:count]} #{'aula'.pluralize(regular_price[:count], :'pt-BR')} #{'regular'.pluralize(regular_price[:count], :'pt-BR')} por semana.",
            description: "regular_class_#{regular_price[:count]}_private_lessons_0_with_0_weekly_experience"
          }
        ]
      end
    end

    def private_and_regular_combinations
      private_plan_price.prices.map do |private_price|
        private_price[:price] = 75 if private_price[:count] == 1

        regular_plan_price.prices.map do |regular_price|
          [
            {
              regular_classes_per_week: regular_price[:count],
              private_lessons_per_month: private_price[:count],
              week_experience: false,
              regular_price: regular_price[:price] + private_price[:price],
              week_experience_price: 0,
              name: "#{regular_price[:count]} #{'aula'.pluralize(regular_price[:count], :'pt-BR')} #{'regular'.pluralize(regular_price[:count], :'pt-BR')} por semana, mais #{private_price[:count]} #{'aula'.pluralize(private_price[:count], :'pt-BR')} #{'particular'.pluralize(private_price[:count], :'pt-BR')} por mês",
              description: "regular_class_#{regular_price[:count]}_private_lessons_#{private_price[:count]}_with_0_weekly_experience"
            }
          ]
        end
      end
    end

    def weekly_combination
      [
        {
          regular_classes_per_week: 1,
          private_lessons_per_month: 0,
          week_experience: true,
          regular_price: regular_plan_price.prices.first[:price],
          week_experience_price: week_experience_price,
          name: '1 aula regular por semana, com 1 semana de espiadinha',
          description: 'regular_class_1_private_lessons_0_with_1_weekly_experience'
        }
      ]
    end

    def private_plan_price
      @private_plan_price ||= PlanPrice.find_by!(kind: 'private_lessons')
    end

    def regular_plan_price
      @regular_plan_price ||= PlanPrice.find_by!(kind: 'regular_classes')
    end

    def week_experience_plan_price
      @week_experience_plan_price ||= PlanPrice.find_by!(kind: 'week_experience')
    end

    def week_experience_price
      week_experience_plan_price.prices.first[:price]
    end
  end
end
# rubocop:enable Metrics/MethodLength, Layout/LineLength, Metrics/AbcSize
