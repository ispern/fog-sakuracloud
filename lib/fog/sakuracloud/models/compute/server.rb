require 'fog/core/model'

module Fog
  module Compute
    class SakuraCloud
      class Server < Fog::Model
        identity :id, :aliases => 'ID'
        attribute :name, :aliases => 'Name'
        attribute :server_plan, :aliases => 'ServerPlan'
        attribute :instance, :aliases => 'Instance'
        attribute :disks, :aliases => 'Disks'
        attribute :interfaces, :aliases => 'Interfaces'

        def save
          requires :name, :server_plan
          data = service.create_server(@attributes).body["Server"]
          merge_attributes(data)
          true
        end

        def boot
          requires :id
          service.boot_server(id)
        end

        def stop(force = false)
          requires :id
          service.stop_server(id, force)
        end

        def reboot(force = false)
          requires :id
          stop(force)
          wait_for { failed? }

          boot
          wait_for { ready? }
        end

        def delete(force = false, disks = [])
          requires :id
          service.delete_server(id, force, disks)
          true
        end
        alias_method :destroy, :delete

        def state
          requires :id
          service.state_server(id).body["Instance"]["Status"]
        end

        def ready?
          state == 'up'
        end

        def failed?
          state == 'down'
        end

        def public_ip_address
          requires :id
          service.get_server(id).body['Server']['Interfaces'].first['IPAddress']
        end

        def private_ip_address
          ip = nil
          self.interfaces.each { |interface|
            if interface['Switch']['Scope'] != 'shared'
              ip = interface['IPAddress']
              break
            end
          }
          ip
        end

        def addresses
          {:address => [public_ip_address]}
        end

      end
    end
  end
end
