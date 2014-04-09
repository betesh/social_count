require 'spec_helper'

module SocialCount
  class TwitterUser
    class << self
      def reset_credentials
        @token_hash = nil
        @access_token = nil
        @credentials = nil
      end
    end
  end
end

describe SocialCount::TwitterUser do
  before(:all) do
    SocialCount.credentials = TestCredentials::INSTANCE
  end

  describe "name" do
    it "cannot be an empty string" do
      expect{SocialCount::TwitterUser.new('')}.to raise_error(SocialCount::Error, "SocialCount::TwitterUser#name cannot be blank")
    end
    it "cannot be nil" do
      expect{SocialCount::TwitterUser.new(nil)}.to raise_error(SocialCount::Error, "SocialCount::TwitterUser#name cannot be blank")
    end
  end

  describe "non-existent user" do
    def non_existent_user
      SocialCount::TwitterUser.new('no_such_agency')
    end

    it "should fail gracefully" do
      expect{non_existent_user}.to_not raise_error
    end

    it "should be invalid" do
      non_existent_user.valid?.should be_false
    end

    it "should have nil follower_count" do
      non_existent_user.follower_count.should be_nil
    end
  end

  ['@tsa', 'tsa'].each do |username|
  describe "existent user" do
    before(:each) do
      @twitter = SocialCount::TwitterUser.new(username)
    end

    it "should be valid" do
      @twitter.valid?.should be_true
    end

    it "should get the follow count" do
      @twitter.follower_count.should eq(12872)
    end
  end

  describe "expired credentials" do
    before(:all) do
      @old_credentials = SocialCount.credentials
      SocialCount::TwitterUser.reset_credentials
      SocialCount.credentials = TestCredentials::EXPIRED_CREDENTIALS
      @twitter = SocialCount::TwitterUser.new(username)
    end
    it "should raise an exception" do
      expect{@twitter.follower_count}.to raise_error(SocialCount::TwitterApiError, "Code(s): 32\nSee code explanations at https://dev.twitter.com/docs/error-codes-responses")
    end
    after(:all) do
      SocialCount.credentials = @old_credentials
      SocialCount::TwitterUser.reset_credentials
    end
  end
  end
end
