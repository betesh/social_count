require 'active_support/core_ext/object/blank'
require "social_count/version"
require "social_count/error"
require "social_count/facebook_user"
require "social_count/twitter_user"

module SocialCount
  REQUIRED_CREDENTIALS = [:twitter_consumer_key, :twitter_consumer_secret, :twitter_oauth_token, :twitter_oauth_token_secret, :fb_app_id, :fb_app_secret]
  class Credentials
    attr_accessor *REQUIRED_CREDENTIALS
  end
  class << self
    def credentials
      raise SocialCount::Error, "You must set SocialCount.credentials before making an API call" if @credentials.nil?
      @credentials
    end

    def credentials=(credentials)
      validate_credentials(credentials)
      @credentials = credentials
    end
    private
      def validate_credentials(_credentials)
        REQUIRED_CREDENTIALS.each do |attr|
          raise SocialCount::Error, "SocialCount.credentials must respond to #{attr}" unless _credentials.respond_to?(attr.to_s)
          raise SocialCount::Error, "SocialCount.credentials.#{attr} cannot be blank" if _credentials.__send__(attr.to_s).blank?
        end
      end
  end
end
