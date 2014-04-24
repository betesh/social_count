require 'spec_helper'

module SocialCount
  class FacebookUser
    class << self
      def reset_credentials
        @access_token = nil
        @access_url = nil
        @credentials = nil
      end
    end
  end
end

describe SocialCount::FacebookUser do
  before(:all) do
    SocialCount.credentials = TestCredentials::INSTANCE
  end

  def username
    @username ||= 'zuck'
  end
  def access_token_did_not_match_specified_format
    @access_token_did_not_match_specified_format ||= "Facebook Access Token #{@access_token} did not match specified format"
  end

  describe "class methods" do
    it "should receive an access token" do
      @access_token = described_class.access_token.split("|")
      @access_token.count.should eq(2), access_token_did_not_match_specified_format
      @access_token[0].should eq(SocialCount.credentials.fb_app_id), access_token_did_not_match_specified_format
      @access_token[1].should match(/[_A-Za-z0-9]{27}/), access_token_did_not_match_specified_format
    end
  end

  describe "name" do
    it "cannot be an empty string" do
      expect{described_class.new('')}.to raise_error(SocialCount::Error, "SocialCount::FacebookUser#name cannot be blank")
    end
    it "cannot be nil" do
      expect{described_class.new(nil)}.to raise_error(SocialCount::Error, "SocialCount::FacebookUser#name cannot be blank")
    end
  end


  describe "user that supports following" do
    subject { described_class.new(username) }
    it { should be_valid }
    it "should get user data" do
      user = subject.user
      user.username.should eq(username)
      user.first_name.should eq('Mark')
      user.last_name.should eq('Zuckerberg')
      user.link.should eq("https://www.facebook.com/#{username}")
      user.gender.should eq('male')
    end
    its(:id) { should == 4 }
    its(:follower_count) { should be_a(Fixnum) }
    its(:follower_count) { should == 27467193 }
    its(:friend_count) { should be_nil }
  end

  describe "user that supports friending" do
    subject { described_class.new('jose.valim') }
    its(:friend_count) { should be_a(Fixnum) }
    its(:friend_count) { should == 837 }
    its(:follower_count) { should be_nil }
  end

  describe "non-existent user" do
    def non_existent_user
      described_class.new("george_orwell")
    end
    it "should fail gracefully" do
      expect{non_existent_user}.to_not raise_error
    end
    it "should be invalid" do
      non_existent_user.valid?.should be_false
    end
    it "should have nil user" do
      non_existent_user.user.should be_nil
    end
    it "should have nil id" do
      non_existent_user.id.should be_nil
    end
    it "should have nil friend_count" do
      non_existent_user.friend_count.should be_nil
    end
    it "should have nil follower_count" do
      non_existent_user.follower_count.should be_nil
    end
  end

  describe "expired credentials" do
    before(:all) do
      @old_credentials = SocialCount.credentials
      described_class.reset_credentials
      SocialCount.credentials = TestCredentials::EXPIRED_CREDENTIALS
      @facebook = described_class.new(username)
    end
    it "should raise an exception when generating the access token" do
      expect{@facebook.follower_count}.to raise_error(SocialCount::FacebookApiError, "Code: 1\nFacebook API returned the following error: Error validating client secret.\nSee code explanations at https://developers.facebook.com/docs/reference/api/errors/")
    end
    after(:all) do
      SocialCount.credentials = @old_credentials
      described_class.reset_credentials
    end
  end
end
