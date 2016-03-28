# coding: utf-8

module Fog
  module Compute
    class SakuraCloud
      class Real
        def state_server(id)
          request(
            :headers => {
              'Authorization' => "Basic #{@auth_encode}"
            },
            :expects  => [200],
            :method => 'GET',
            :path => "#{Fog::SakuraCloud.build_endpoint(@api_zone)}/server/#{id}/power"
          )
        end
      end # Real

      class Mock
        def state_server(id)
          response = Excon::Response.new
          response.status = 201
          response.body = {
          }
          response
        end
      end
    end # SakuraCloud
  end # Compute
end # Fog
