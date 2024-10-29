require 'rails_helper'

RSpec.describe IpStack do
  describe '.get_location' do
    let(:ip_or_url) { '46.242.241.35' }
    let(:api_key) { 'test_api_key' }
    let(:response_body) do
      {
        'ip' => '46.242.241.35',
        'country_name' => 'Poland',
        'city' => 'Katowice',
        'latitude' => 50.264893,
        'longitude' => 19.023781
      }
    end

    before do
      allow(Rails.application.config).to receive(:ip_stack_api_key).and_return(api_key)
    end

    context 'when the request is successful' do
      before do
        stub_request(:get, "https://api.ipstack.com/#{ip_or_url}?access_key=#{api_key}&fields=#{IpStack::FIELDS.join(",")}")
          .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns the parsed response' do
        result = IpStack.get_location(ip_or_url)
        expect(result).to eq(response_body.with_indifferent_access)
      end
    end

    context 'when the request fails' do
      before do
        stub_request(:get, "https://api.ipstack.com/#{ip_or_url}?access_key=#{api_key}&fields=#{IpStack::FIELDS.join(",")}")
          .to_return(status: 400, body: { 'error' => { 'info' => 'Invalid request' } }.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises an IpStackError' do
        expect { IpStack.get_location(ip_or_url) }.to raise_error(Errors::IpStackError, 'Invalid request')
      end
    end

    context 'when there is a network error' do
      before do
        allow(IpStack).to receive(:get).and_raise(SocketError.new('Failed to open TCP connection'))
      end

      it 'raises a NetworkError' do
        expect { IpStack.get_location(ip_or_url) }.to raise_error(Errors::NetworkError, 'Failed to open TCP connection')
      end
    end
  end

  describe '.api_key' do
    context 'when the API key is set' do
      let(:api_key) { 'test_api_key' }

      before do
        allow(Rails.application.config).to receive(:ip_stack_api_key).and_return(api_key)
      end

      it 'returns the API key' do
        expect(IpStack.api_key).to eq(api_key)
      end
    end

    context 'when the API key is not set' do
      before do
        allow(Rails.application.config).to receive(:ip_stack_api_key).and_return(nil)
      end

      it 'raises an IpStackError' do
        expect { IpStack.api_key }.to raise_error(Errors::IpStackError, 'IP_STACK_API_KEY variable is not set')
      end
    end
  end
end