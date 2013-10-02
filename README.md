# SocialCount

This gem is an incredibly ligh-weight wrapper for finding how many facebook friends and twitter followers someone has.

## Installation

    gem 'social_count' # In your Gemfile

    $ gem install social_count # Install locally

## Usage

1) Configure your credentials:

    SocialCount::Credentials = Struct.new(:twitter_consumer_key, :twitter_consumer_secret, :twitter_oauth_token, :twitter_oauth_token_secret, :fb_app_id, :fb_app_secret)

2) Get the Facebook follower count of any business page:

    SocialCount::FacebookUser.new('zuck').follower_count # Find out how many people are following Mark Zuckerberg
    SocialCount::FacebookUser.new('zuck').friend_count # nil -- Mark has a business page because he's so famous

2) Get the Facebook friend count of any regular facebook user:

    SocialCount::FacebookUser.new('jose.valim').friend_count # Find out how many friends Jose Valim has -- I wish he were as famous as Mark
    SocialCount::FacebookUser.new('jose.valim').follower_count # nil
    # I think there are more Devise users than Facebook users in China.  As least that's on place where Jose is more famous than Mark


3) Get the Twitter follower count of any user:

    SocialMedia::TwitterUser.new('tsa').follower_count # Find out how many people are following the Transportation security Administration

4) Check if someone is on Facebook:

    orwell = SocialCount::FacebookUser.new('george_orwell')
    orwell.valid? # False -- Not everyone is cool enough to be one Facebook
    orwell.friend_count # nil

5) Check if someone is on Twitter:

    nsa = SocialCount::TwitterUser.new('no_such_agency')
    nsa.valid? # False -- Nobody can follow the NSA
    nsa.follower_count # nil
