# frozen_string_literal: true

require 'open-uri'
# require 'nokogiri'
require 'json'

module JSONSchema
  # https://sendgrid.api-docs.io/
  # https://github.com/sendgrid/sendgrid-oai/
  REFERENCE_URL = 'https://raw.githubusercontent.com/sendgrid/sendgrid-oai/master/oai.json'

  class << self
    def fetch
      doc = JSON.parse(OpenURI.open_uri(REFERENCE_URL).read)
      schema = doc.fetch('paths').fetch('/mail/send').fetch('post').fetch('parameters')
                  .find { |i| i.fetch('name') == 'body' }.fetch('schema')
      definitions = doc.fetch('definitions')
      schema.merge!('definitions' => definitions)

      # WORKAROUND: Subject/Content requires one of the parameters
      # cf. https://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/index.html#-Request-Body-Parameters
      schema['required'].delete('subject')
      schema['required'].delete('content')

      schema
    end
  end
end
