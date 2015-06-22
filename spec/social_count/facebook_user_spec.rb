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

  let(:username) { :zuck }
  subject { described_class.new(username) }

  let(:access_token_did_not_match_specified_format) { "Facebook Access Token #{access_token} did not match specified format" }

  describe "class methods" do
    let(:access_token) { described_class.access_token.split("|") }

    it "should receive an access token" do
      expect(access_token.count).to eq(2), access_token_did_not_match_specified_format
      expect(access_token[0]).to eq(SocialCount.credentials.fb_app_id), access_token_did_not_match_specified_format
      expect(access_token[1]).to match(/[-_A-Za-z0-9]{27}/), access_token_did_not_match_specified_format
    end
  end

  describe "name" do
    describe "when empty String" do
      let(:username) { "" }

      it "should raise an error" do
        expect{subject}.to raise_error(SocialCount::Error, "SocialCount::FacebookUser#name cannot be blank")
      end
    end

    describe "when nil" do
      let(:username) { nil }
      it "should raise an error" do
        expect{subject}.to raise_error(SocialCount::Error, "SocialCount::FacebookUser#name cannot be blank")
      end
    end
  end

  describe "user that supports following" do
    it { should be_valid }

    it "should get user data" do
      user = subject.user
      expect(user.username).to eq(username)
      expect(user.first_name).to eq('Mark')
      expect(user.last_name).to eq('Zuckerberg')
      expect(user.link).to eq("https://www.facebook.com/#{username}")
      expect(user.gender).to eq('male')
      expect(user.id).to eq(4)
    end

    it "should get follower_count" do
      expect(subject.follower_count).to eq(27467193)
    end

    it "should have nil friend_count" do
      expect(subject.friend_count).to be_nil
    end
  end

  describe "user that supports friending" do
    let(:username) { 'jose.valim' }
    it "should get friend_count" do
      expect(subject.friend_count).to eq(900)
    end

    it "should have nil follower_count" do
      expect(subject.follower_count).to be_nil
    end
  end

  describe "non-existent user" do
    let(:username) { "george_orwell" }

    it "should fail gracefully" do
      expect{subject}.to_not raise_error
    end

    it "should be invalid" do
      expect(subject).not_to be_valid
    end
    it "should have nil user" do
      expect(subject.user).to be_nil
    end

    it "should have nil id" do
      expect(subject.id).to be_nil
    end

    it "should have nil friend_count" do
      expect(subject.friend_count).to be_nil
    end

    it "should have nil follower_count" do
      expect(subject.follower_count).to be_nil
    end
  end

  describe "expired credentials" do
    before(:each) do
      allow(SocialCount).to receive(:credentials).and_return(TestCredentials::EXPIRED_CREDENTIALS)
      described_class.reset_credentials
    end

    it "should raise an exception when generating the access token" do
      expect{subject.follower_count}.to raise_error(SocialCount::FacebookApiError, "Code: 1\nFacebook API returned the following error: Error validating client secret.\nSee code explanations at https://developers.facebook.com/docs/reference/api/errors/")
    end

    after(:each) do
      described_class.reset_credentials
    end
  end
end
