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

  subject { described_class.new(username) }

  describe "name" do
    it "cannot be an empty string" do
      expect{described_class.new('')}.to raise_error(SocialCount::Error, "SocialCount::TwitterUser#name cannot be blank")
    end
    it "cannot be nil" do
      expect{described_class.new(nil)}.to raise_error(SocialCount::Error, "SocialCount::TwitterUser#name cannot be blank")
    end
  end

  describe "non-existent user" do
    let(:username) { :no_such_agency }

    it "should fail gracefully" do
      expect{subject}.not_to raise_error
    end

    it { should_not be_valid }

    it "should have nil follower_count" do
      expect(subject.follower_count).to be_nil
    end
  end

  ['@tsa', 'tsa'].each do |username|
    let(:username) { username }

    describe "existent user" do
      it { should be_valid }

      it "should get the follow count" do
        expect(subject.follower_count).to eq(45977)
      end
    end

    describe "expired credentials" do
      before(:each) do
        allow(SocialCount).to receive(:credentials).and_return(TestCredentials::EXPIRED_CREDENTIALS)
        described_class.reset_credentials
      end

      it "should raise an exception" do
        expect{subject.follower_count}.to raise_error(SocialCount::TwitterApiError, "Code(s): 32\nSee code explanations at https://dev.twitter.com/docs/error-codes-responses")
      end

      after(:each) do
        described_class.reset_credentials
      end
    end
  end
end
