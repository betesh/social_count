# SocialCount

This gem is an incredibly ligh-weight wrapper for finding how many facebook friends and twitter followers someone has.

## Installation

    gem 'social_count' # In your Gemfile

    $ gem install social_count # Install locally

## Usage

1) Configure your credentials:

    SocialCount::Credentials = Struct.new(:twitter_consumer_key, :twitter_consumer_secret, :twitter_oauth_token, :twitter_oauth_token_secret, :fb_app_id, :fb_app_secret)

2) Get the Facebook friend count of any user:

    SocialCount::FacebookUser.new('zuck').friend_count # Find out how many friends Mark Zuckerberg has

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
