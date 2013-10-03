require 'fb_graph'
require 'social_count/api_base'

module SocialCount
  class FacebookUser < ApiBase
    DOMAIN = "https://graph.facebook.com"
    def valid?
      return @valid unless @valid.nil?
      @valid = self.class.get_http_response("#{DOMAIN}/#{name}").is_a?(Net::HTTPOK)
    end
    def user
      return unless valid?
      @user ||= FbGraph::User.fetch(name, :access_token => URI.escape(self.class.access_token))
    end
    def id
      return unless valid?
      @id ||= user.identifier.to_i
    end
    def friend_count
      run_query(:friend)
    end
    def follower_count
      count = run_query(:subscriber)
      count.to_i.zero? ? nil : count
    end
    private
      def run_query(column)
        return unless valid?
        url = "#{DOMAIN}/fql?q=#{query(column)}"
        response = self.class.get_http_response(url)
        JSON.parse(response.body)["data"][0]["#{column}_count"]
      end
      def query(column)
        "SELECT #{column}_count FROM user WHERE uid=#{id}"
      end

    class << self
      def access_token
        @access_token ||= get_http_response(access_url).body.split("access_token=")[1]
      end
      private
        def access_url
          @access_url ||= "#{DOMAIN}/oauth/access_token?client_id=#{credentials.fb_app_id}&client_secret=#{credentials.fb_app_secret}&grant_type=client_credentials"
        end
    end
  end
end
