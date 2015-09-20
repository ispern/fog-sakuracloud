# coding: utf-8

module Fog
  module DNS
    class SakuraCloud
      class Real
        def create_zone(options)
          name = options[:name] ? options[:name] : options[:zone]
          body = {
            "CommonServiceItem"=>{
              "Name"=>name,
              "Status"=>{"Zone"=>options[:zone]},
              "Provider"=>{"Class"=>"dns"},
              "Description"=> options[:description]
            }
          }

          request(
            :headers => {
              'Authorization' => "Basic #{@auth_encord}"
            },
            :expects  => 201,
            :method => 'POST',
            :path => "#{Fog::SakuraCloud::SAKURACLOUD_API_ENDPOINT}/commonserviceitem",
            :body => Fog::JSON.encode(body)
          )
        end
      end # Real

      class Mock
        def create_zone(options)
          response = Excon::Response.new
          response.status = 201
          response.body = {
          }
          response
        end
      end
    end # SakuraCloud
  end # DNS
end # Fog
