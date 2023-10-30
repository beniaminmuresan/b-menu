module Edamam
  class MealPlanner
    attr_reader :menu_params

    def initialize(menu_params)
      @menu_params = menu_params
    end

    def self.generate(menu_params)
      new(menu_params).generate
    end

    def generate
      JSON.parse(response.body).deep_symbolize_keys[:selection]
    end

    private

      def response
        edamam.post('/api/meal-planner/v1/f3dd90de/select') do |req|
          req.body = request_body
        end
      end

      def request_body
        {
          size: 4,
          plan: {
            sections: { Breakfast: {}, Lunch: {}, Dinner: {} },
            fit: { ENERC_KCAL: { min: 1000, max: 3000 } },
            accept: { all: [ { diet: menu_params[:diet] }, { cuisine: menu_params[:cuisine] }, { health: menu_params[:health] } ] }
          }
        }.to_json
      end

      def edamam
        @edamam ||= Faraday.new(url: 'https://api.edamam.com', headers: {
            # 'Accept-Encoding' => 'gzip',
            'accept' => 'application/json',
            'Content-Type' => 'application/json',
            'Edamam-Account-User' => 'f3dd90de',
            'Authorization' => 'Basic ZjNkZDkwZGU6ZGM1MzBkMjdhNDc0MDdiN2YyYmM2MmI3ZDY2N2U3ZDM='
          }
        )
      end
  end
end