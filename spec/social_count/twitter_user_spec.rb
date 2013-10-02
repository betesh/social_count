require 'spec_helper'

describe SocialCount::TwitterUser do
  before(:all) do
    SocialCount.credentials = TestCredentials::INSTANCE
  end
  def username
    @username ||= 'tsa'
  end

  describe "existent user" do
    before(:each) do
      @twitter = SocialCount::TwitterUser.new(username)
    end

    it "should be valid" do
      @twitter.valid?.should be_true
    end

    it "should get the follow count" do
      @twitter.follower_count.should eq(12171)
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
end
