require 'net/http'
require 'active_support/core_ext/object/blank'
require 'social_count/error'

module SocialCount
  class ApiBase
    attr_reader :name
    def initialize(name)
      raise SocialCount::Error, "#{self.class}#name cannot be blank" if name.blank?
      @name = name
    end
    class << self
      def get_http_response(uri)
        uri = URI.escape(uri)
        url = URI.parse(uri)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.request(Net::HTTP::Get.new(uri))
      end
      private
        def credentials
          @credentials ||= SocialCount.credentials
        end
    end
  end
end
