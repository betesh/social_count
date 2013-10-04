module SocialCount
  class Error < StandardError
  end
  class TwitterApiError < Error
    attr_reader :code
    def initialize(msg, code)
      @code = code.is_a?(Array) ? code.join(", ") : code
      super(msg)
    end
    def to_s
      "Code(s): #{code}\nSee code explanations at https://dev.twitter.com/docs/error-codes-responses"
    end
  end
end
