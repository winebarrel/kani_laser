# frozen_string_literal: true

module KaniLaser
  class Client
    INITIALIZE_OPTIONS = %i[
      api_key
      debug
    ].freeze

    DEFAULT_ADAPTERS = [
      Faraday::Adapter::NetHttp,
      Faraday::Adapter::Test,
    ].freeze

    USER_AGENT = "KaniLaser #{KaniLaser::VERSION}"

    # https://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/index.html#-Authentication
    DEFAULT_API_URL = 'https://api.sendgrid.com/v3/mail/send'

    def initialize(options)
      unless options.is_a?(Hash)
        raise ArgumentError, "wrong type argument (given: #{options}:#{options.class}, expected Hash)"
      end

      @options = {}

      INITIALIZE_OPTIONS.each do |key|
        @options[key] = options.delete(key)
      end

      raise ArgumentError, ':api_key is required for initialize' unless @options[:api_key]

      options[:url] ||= DEFAULT_API_URL

      @conn = Faraday.new(options) do |faraday|
        faraday.response :raise_error
        faraday.response :logger, ::Logger.new(STDOUT), bodies: true if @options[:debug]

        yield(faraday) if block_given?

        unless DEFAULT_ADAPTERS.any? { |i| faraday.builder.handlers.include?(i) }
          faraday.adapter Faraday.default_adapter
        end
      end

      @conn.headers[:user_agent] = USER_AGENT
    end

    def send_mail(body)
      raise ArgumentError, "wrong type body (given: #{body}:#{body.class}, expected Hash)" unless body.is_a?(Hash)

      validate!(body)

      api_key = @options.fetch(:api_key)
      @conn.authorization(:Bearer, api_key)

      res = @conn.post do |req|
        req.body = JSON.dump(body)
        req.headers['Content-Type'] = 'application/json'
      end

      res
    end

    private

    def validate!(body)
      JSON::Validator.validate!(KaniLaser::SCHEMA, body)

      attachments = body.fetch('attachments', body.fetch(:attachments, []))
      subject = body.fetch('subject', body[:subject])
      content = body.fetch('content	', body[:content])
      personalizations = body.fetch('personalizations', body.fetch(:personalizations))

      unless subject || personalizations.any? { |i| i.fetch('subject', i[:subject]) }
        raise KaniLaser::Error, "Contains no subject: #{body}"
      end

      unless content || attachments.any? { |i| i.fetch('content', i[:content]) }
        raise KaniLaser::Error, "Contains no content: #{body}"
      end
    end
  end
end
