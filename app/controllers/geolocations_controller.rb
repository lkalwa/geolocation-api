class GeolocationsController < ApplicationController
  before_action :fetch_location, only: [ :create, :show, :destroy ]
  before_action :return_if_exists, only: :create
  before_action :render_not_found, only: [ :show, :destroy ]

  def create
    location_data = IpStack.get_location(geo_params[:ip] || geo_params[:url])
    @geolocation = Geolocation.new(
      url: geo_params[:url],
      country: location_data[:country_name],
      city: location_data[:city],
      latitude: location_data[:latitude],
      longitude: location_data[:longitude],
      ip: location_data[:ip]
    )

    if @geolocation.save
      render json: @geolocation, status: :created
    else
      render json: @geolocation.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @geolocation
  end

  def destroy
    @geolocation.destroy
    head :no_content
  end

  private

  def return_if_exists
    render json: @geolocation, status: :ok if @geolocation
  end

  def fetch_location
    @geolocation = Geolocation.where(ip: geo_params[:ip]).or(Geolocation.where(url: geo_params[:url])).first
  end

  def render_not_found
    render json: "Geolocation not found", status: :not_found unless @geolocation
  end

  def geo_params
    params.require(:geolocation).permit(:ip, :url)
  end
end
