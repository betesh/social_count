require 'twitter_oauth'
require 'social_count/api_base'

module SocialCount
  class TwitterUser < ApiBase
    API_DOMAIN = "https://api.twitter.com"
    USER_DOMAIN = "https://twitter.com"
    CONSUMER_OPTIONS = { :site => API_DOMAIN, :scheme => :header }

    def valid?
      return @valid unless @valid.nil?
      @valid = self.class.get_http_response("#{USER_DOMAIN}/#{name}").is_a?(Net::HTTPOK)
    end

    def follower_count
      return unless valid?
      response = self.class.access_token.request(:get, follower_count_url)
      response = JSON.parse(response.body)
      raise SocialCount::TwitterApiError.new("Twitter API returned the following errors: #{response["errors"]}", response["errors"].collect{|e| e["code"]}) if response["errors"]
      response["followers_count"]
    end

    private
      def follower_count_url
        @follower_count_url ||= "#{API_DOMAIN}/1.1/users/show.json?screen_name=#{URI.escape(name)}"
      end

    class << self
      def access_token
        @access_token ||= OAuth::AccessToken.from_hash(consumer, token_hash)
      end
      private
        def consumer
          @consumer ||= OAuth::Consumer.new(credentials.twitter_consumer_key, credentials.twitter_consumer_secret, CONSUMER_OPTIONS)
        end
        def token_hash
          @token_hash ||= { :oauth_token => credentials.twitter_oauth_token, :oauth_token_secret => credentials.twitter_oauth_token_secret }
        end
    end
  end
end
