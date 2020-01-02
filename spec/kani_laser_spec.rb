# frozen_string_literal: true

RSpec.describe KaniLaser::Client do
  let(:api_key) { 'ZAPZAPZAP' }

  let(:options) { { api_key: api_key } }

  let(:client) do
    described_class.new(options) do |faraday|
      faraday.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post('/v3/mail/send') { [202, {}, ''] }
      end
    end
  end

  context 'when send mail' do
    let(:expected_req_body) do
      {
        'content' => [{
          'type' => 'text/plain',
          'value' => 'Hello, World!',
        }],
        'from' => { 'email' => 'from_address@example.com' },
        'personalizations' => [{
          'subject' => 'Hello, World!',
          'to' => [{ 'email' => 'john@example.com' }],
        }],
      }
    end

    specify 'API is called' do
      res = client.send_mail(
        personalizations: [{
          to: [{ email: 'john@example.com' }],
          subject: 'Hello, World!',
        }],
        from: { email: 'from_address@example.com' },
        content: [{
          type: 'text/plain',
          value: 'Hello, World!',
        }]
      )

      expect(202).to eq(res.status)
    end
  end

  context 'when validation error' do
    specify 'raise error' do
      expect do
        client.send_mail({})
      end.to raise_error(JSON::Schema::ValidationError)
    end
  end

  context 'without subject' do
    specify 'raise error' do
      expect do
        client.send_mail(
          personalizations: [{
            to: [{ email: 'john@example.com' }],
          }],
          from: { email: 'from_address@example.com' },
          content: [{
            type: 'text/plain',
            value: 'Hello, World!',
          }]
        )
      end.to raise_error(/Contains no subject:/)
    end
  end

  context 'without content' do
    specify 'raise error' do
      expect do
        client.send_mail(
          personalizations: [{
            to: [{ email: 'john@example.com' }],
            subject: 'Hello, World!',
          }],
          from: { email: 'from_address@example.com' }
        )
      end.to raise_error(/Contains no content:/)
    end
  end

  context 'no personalizations item' do
    specify 'raise error' do
      expect do
        client.send_mail(
          personalizations: [],
          from: { email: 'from_address@example.com' },
          content: [{
            type: 'text/plain',
            value: 'Hello, World!',
          }]
        )
      end.to raise_error(JSON::Schema::ValidationError)
    end
  end
end
