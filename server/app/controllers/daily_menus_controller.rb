class DailyMenusController < ApplicationController
  def create
    recipes = DailyMenu.generate(daily_menu_params)
    render json: recipes
  end

  private

    def daily_menu_params
      params.require(:daily_menu).permit(diet: [], health: [], cuisine: []).to_h.deep_symbolize_keys
    end
end
