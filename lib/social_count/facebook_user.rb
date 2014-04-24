require 'fb_graph'
require 'social_count/api_base'

module SocialCount
  class FacebookUser < ApiBase
    def valid?
      return @valid unless @valid.nil?
      @valid = self.class.get_http_response("#{FbGraph::ROOT_URL}/#{name}").is_a?(Net::HTTPOK)
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
        url = "#{FbGraph::ROOT_URL}/fql?q=#{query(column)}"
        response = self.class.get_http_response(url)
        response = JSON.parse(response.body)
        data = response['data']
        raise SocialCount::FacebookApiError.new("The social_count gem could not parse the response from the Facebook Graph API: #{response}", 0) unless data.is_a?(Array)
        return nil if data.empty?
        raise SocialCount::FacebookApiError.new("The social_count gem could not parse the response from the Facebook Graph API: #{response}", 0) unless data[0].is_a?(Hash)
        data[0]["#{column}_count"]
      end
      def query(column)
        "SELECT #{column}_count FROM user WHERE uid=#{id}"
      end

    class << self
      def access_token
        return @access_token unless @access_token.nil?
        response = get_http_response(access_url)
        unless response.is_a?(Net::HTTPOK)
          response = JSON.parse(response.body)
          raise SocialCount::FacebookApiError.new("Facebook API returned the following error: #{response["error"]["message"]}", response["error"]["code"])
        end
        @access_token = response.body.split("access_token=")[1]
      end
      private
        def access_url
          @access_url ||= "#{FbGraph::ROOT_URL}/oauth/access_token?client_id=#{credentials.fb_app_id}&client_secret=#{credentials.fb_app_secret}&grant_type=client_credentials"
        end
    end
  end
end
