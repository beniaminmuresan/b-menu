class DailyMenu
  attr_reader :menu_params, :meal_plan_parsed

  def initialize(menu_params)
    @menu_params = menu_params
    @meal_plan_parsed = {}
  end

  def self.generate(menu_params)
    new(menu_params).generate
  end

  def generate
    meal_plan.each_with_index do |section, index|
      %w[Breakfast Lunch Dinner].each do |time_serve|
        meal_plan_parsed[section.dig(:sections, time_serve.to_sym, :assigned)] = {
          time_serve:, date: Date.today + index.days
        }
      end
    end

    parsed_recipes_data = recipes_data[:hits].map do |recipe_data|
      recipe_data[:recipe][:time_serve] = meal_plan_parsed[recipe_data[:recipe][:uri]][:time_serve]
      recipe_data[:recipe][:date] = meal_plan_parsed[recipe_data[:recipe][:uri]][:date]
      recipe_data
    end
    parsed_recipes_data.map { |recipe_data| recipe_data[:recipe].slice(:label, :image, :ingredients, :date, :time_serve) }
                       .group_by { |recipe| recipe[:date] }
  end

  def meal_plan
    @meal_plan ||= Edamam::MealPlanner.generate(menu_params)
  end

  def recipes_data
    @recipes_data = Edamam::Recipes.by_uri(meal_plan_parsed.keys)
  end
end