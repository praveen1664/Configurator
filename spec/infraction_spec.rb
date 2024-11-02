require_relative 'spec_helper'
require_relative '../lib/infraction'

describe Infraction do

  describe Infraction::Nginx do

    describe 'proxy' do

      it 'should be able to create nginx config for a real-world proxy pass example' do
        config = Infraction.nginx do
          pass_through('thoughtworks-studios.com').
              including('www').
              on(80).
              forward_to('68.64.190.188')
        end

        expect(config).to match_config 'server {
                                        listen 80;
                                        server_name thoughtworks-studios.com www.thoughtworks-studios.com;

                                        location / {
                                          proxy_pass                        http://68.64.190.188;
                                          proxy_set_header Host             $http_host;
                                        }
                                    }'
      end
    end

    describe 'redirect' do

      let(:redirect_config) do
        Infraction.nginx do
          redirect('/blogs/atom.xml').to('http://feeds.feedburner.com/thoughtworks-blogs')
        end
      end

      it 'should be abe to create nginx redirect config' do
        expect(redirect_config).to match_config '
                  location /blogs/atom.xml {
                       rewrite ^/blogs/atom.xml$ http://feeds.feedburner.com/thoughtworks-blogs permanent;
                  }'
      end
    end


  end
end