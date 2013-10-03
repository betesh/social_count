require 'spec_helper'

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
      @access_token = SocialCount::FacebookUser.access_token.split("|")
      @access_token.count.should eq(2), access_token_did_not_match_specified_format
      @access_token[0].should eq(SocialCount.credentials.fb_app_id), access_token_did_not_match_specified_format
      @access_token[1].should match(/[_A-Za-z0-9]{27}/), access_token_did_not_match_specified_format
    end
  end

  describe "name" do
    it "cannot be an empty string" do
      expect{SocialCount::TwitterUser.new('')}.to raise_error(SocialCount::Error, "SocialCount::TwitterUser#name cannot be blank")
    end
    it "cannot be nil" do
      expect{SocialCount::TwitterUser.new(nil)}.to raise_error(SocialCount::Error, "SocialCount::TwitterUser#name cannot be blank")
    end
  end


  describe "user that supports following" do
    before(:all) do
      @facebook = SocialCount::FacebookUser.new(username)
    end
    it "should be valid" do
      @facebook.valid?.should be_true
    end
    it "should get user data" do
      user = @facebook.user
      user.username.should eq(username)
      user.first_name.should eq('Mark')
      user.last_name.should eq('Zuckerberg')
      user.link.should eq("http://www.facebook.com/#{username}")
      user.gender.should eq('male')
    end
    it "should get the user's id" do
      @facebook.id.should eq(4)
    end
    it "should get the user's follower count" do
      count = @facebook.follower_count
      count.should be_a(Fixnum)
      count.should eq(19528198)
    end
    it "should handle friend_count gracefully" do
      @facebook.friend_count.should be_nil
    end
  end

  describe "user that supports friending" do
    before(:all) do
      @facebook = SocialCount::FacebookUser.new('jose.valim')
    end
    it "should get the user's friend count" do
      count = @facebook.friend_count
      count.should be_a(Fixnum)
      count.should eq(568)
    end
    it "should handle friend_count gracefully" do
      @facebook.follower_count.should be_nil
    end
  end

  describe "non-existent user" do
    def non_existent_user
      SocialCount::FacebookUser.new("george_orwell")
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
end
