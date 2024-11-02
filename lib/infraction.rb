module Infraction
  class BuildContext
    def exec(&block)
      builder = instance_eval(&block)
      builder.generate
    end

  end

  def self.nginx(&block)
    Nginx::NginxBuildContext.new.exec &block
  end

  module Nginx
    module Dsl
      def pass_through(host)
        Infraction::Nginx::PassthroughBuilder.new(host)
      end

      def redirect(source_url)
        Infraction::Nginx::RedirectBuilder.new(source_url)
      end

    end

    class NginxBuildContext < ::Infraction::BuildContext
      include Nginx::Dsl
    end

    class RedirectBuilder
      def initialize(source_url)
        @source_url = source_url
      end

      def to(destination_url)
        @destination_url = destination_url
        self
      end

      def generate
        "
        location #{@source_url} {
          rewrite ^#{@source_url}$ #{@destination_url} permanent;
        }
        "
      end
    end

    class PassthroughBuilder
      def initialize(host)
        @host = host
      end

      def including(subdomain)
        @subdomain = subdomain
        self
      end

      def on(port)
        @port = port
        self
      end

      def forward_to(host)
        @forward_host = host
        self
      end

      def generate
        "server {
            listen #{@port};
            server_name #{hosts};

            location / {
               proxy_pass                        http://#{@forward_host};
               proxy_set_header Host             $http_host;
            }

          }"
      end

      private

      def hosts
        return @host unless @subdomain
        "#{@host} #{@subdomain}.#{@host}"
      end
    end
  end
end