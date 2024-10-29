require 'rails_helper'
WebMock.allow_net_connect!

RSpec.describe "Geolocations", type: :request do
  let(:valid_attributes) do
    {
      ip: '46.242.241.35',
      country: 'Poland',
      city: 'Katowice',
      latitude: 50.264893,
      longitude: 19.023781,
      url: 'www.katowice.pl'
    }
  end
  let(:invalid_attributes) { { url: 'null', ip: 'null' } }
  let(:geolocation) { Geolocation.create! valid_attributes }
  let(:json_headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }
  end

  describe "GET #show" do

    context "with valid params" do
      it "returns a success response" do
        get geolocation_path(geolocation: { url: geolocation.url }), headers: json_headers
        expect(response).to be_successful
      end

      it "works with ip" do
        get geolocation_path(geolocation: { ip: geolocation.ip }), headers: json_headers
        expect(response).to be_successful
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "with invalid params" do
      it "returns a not found response" do
        get geolocation_path(geolocation: { ip_or_url: 'invalid' }), headers: json_headers
        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Geolocation" do
        expect {
          post geolocations_path(geolocation: valid_attributes), headers: json_headers)
        }.to change(Geolocation, :count).by(1)
      end

      it "renders a JSON response with the new geolocation" do
        post geolocations_path(geolocation: valid_attributes), headers: json_headers)
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to match(/#{valid_attributes[:url]}/)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new geolocation" do
        post geolocations_path(geolocation: invalid_attributes), headers: json_headers)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "when a network error occurs" do
      before do
        allow(IpStack).to receive(:get_location).and_raise(Errors::NetworkError)
      end

      it "renders a network error response" do
        post geolocations_path(geolocation: valid_attributes), headers: json_headers
        expect(response).to have_http_status(:service_unavailable)
        expect(response.body).to match(/problems accessing geolocation provider, check your internet connection/)
      end
    end

    context "when an IpStack error occurs" do
      before do
        allow(IpStack).to receive(:get_location).and_raise(Errors::IpStackError.new("IpStack service error"))
      end

      it "renders an IpStack error response" do
        post geolocations_path(geolocation: valid_attributes), headers: json_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to match(/IpStack service error/)
      end
    end
  end

  describe "DELETE #destroy" do
    context "with valid params" do
      it "destroys the requested geolocation" do
        geolocation = Geolocation.create! valid_attributes
        expect {
          delete geolocation_path(geolocation: { ip: geolocation.ip }), headers: json_headers
        }.to change(Geolocation, :count).by(-1)
      end

      it "returns no content" do
        geolocation = Geolocation.create! valid_attributes
        delete geolocation_path(geolocation: { url: geolocation.url }), headers: json_headers
        expect(response).to have_http_status(:no_content)
      end
    end

    context "with invalid params" do
      it "returns a not found response" do
        delete geolocation_path(geolocation: { url: 'invalid' }), headers: json_headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end