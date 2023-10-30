module Edamam
  class Recipes
    def self.by_uri(uris)
      params = {
        'app_id' => 'f3dd90de', 'app_key' => 'dc530d27a47407b7f2bc62b7d667e7d3',
        'type' => 'public', 'beta' => false, 'uri' => uris
      }
      response = conn.get('/api/recipes/v2/by-uri', params)
      JSON.parse(response.body).deep_symbolize_keys
    end

    private

      def self.conn
        connection_params = {
          url: 'https://api.edamam.com',
          headers: {
            # 'Accept-Encoding' => 'gzip',
            'Accept' => 'application/json',
            'Content-Type' => 'application/json',
            'Edamam-Account-User' => 'f3dd90de',
            'Accept-Language' => 'en'
          } 
        }
        connection = Faraday.new(connection_params) do |faraday|
          faraday.request :url_encoded
          faraday.response :logger
          faraday.adapter Faraday.default_adapter
        end
        connection.options[:params_encoder] = Faraday::FlatParamsEncoder
        connection
      end
  end
end