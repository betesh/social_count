class TestCredentials
  attr_reader :twitter_consumer_key, :twitter_consumer_secret, :twitter_oauth_token, :twitter_oauth_token_secret, :fb_app_id, :fb_app_secret
  def initialize twitter_consumer_key, twitter_consumer_secret, twitter_oauth_token, twitter_oauth_token_secret, fb_app_id, fb_app_secret
    @twitter_consumer_key, @twitter_consumer_secret, @twitter_oauth_token, @twitter_oauth_token_secret, @fb_app_id, @fb_app_secret = twitter_consumer_key, twitter_consumer_secret, twitter_oauth_token, twitter_oauth_token_secret, fb_app_id, fb_app_secret
  end
  credentials_file = File.expand_path("#{__FILE__}/../credentials.rb")
  unless File.exists?(credentials_file)
    puts "Please configure your Facebook and Twitter application credentials by copying #{credentials_file}.example to #{credentials_file} and configuring the required values there appropriately."
    exit
  end
end
