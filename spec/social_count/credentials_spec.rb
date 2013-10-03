require 'spec_helper'

module SocialCount
  class << self
    def reset_credentials
      @credentials = nil
    end
  end
end


def credentials_without(attr)
  SocialCount::REQUIRED_CREDENTIALS.dup.tap { |a| a.delete(attr) }
end

def class_that_doesnt_respond_to(credential)
  Class.new do
    attributes = credentials_without(credential)
    attributes.each do |a|
      define_method(a) { '123' }
    end
  end
end

describe SocialCount::Credentials do
  SocialCount::REQUIRED_CREDENTIALS.each do |credential|
    it "should require credentials to have a #{credential}" do
      credentials = class_that_doesnt_respond_to(credential)
      expect{SocialCount.credentials = credentials.new}.to raise_error(SocialCount::Error, "SocialCount.credentials must respond to #{credential}")
    end
  end

  it "shouldn't change state when an exception is raised" do
    credentials = class_that_doesnt_respond_to(:twitter_consumer_secret)
    SocialCount.reset_credentials
    expect{SocialCount.credentials = credentials.new}.to raise_error(SocialCount::Error, "SocialCount.credentials must respond to twitter_consumer_secret")
    expect(SocialCount.instance_variable_get("@credentials")).to be_nil
  end

  it "shouldn't allow access untill credentials have been set" do
    SocialCount.reset_credentials
    expect{SocialCount.credentials}.to raise_error(SocialCount::Error, "You must set SocialCount.credentials before making an API call")
  end

  it "can be a SocialCount::Credentials instance" do
    expect{SocialCount.credentials = SocialCount::Credentials.new}.to_not raise_error
  end
end
