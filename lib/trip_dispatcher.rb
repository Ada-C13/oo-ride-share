require "csv"
require "time"
# require 'pry'

require_relative "passenger"
require_relative "trip"
require_relative "driver"

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips, :drivers

    def initialize(directory: "./support")
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      # Wave 2: load Drivers
      @drivers = Driver.load_all(directory: directory)
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    # find driver
    def find_driver(id)
      Driver.validate_id(id)
      return @drivers.find { |driver| driver.id == id }
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end
  end

  # Wave 3
  # creates a trip and assigns an available driver
  def request_trip(passenger_id)
    @drivers.each do |driver|
      if driver.status == :AVAILABLE
        driver = dispatch_driver # make this loop end faster
      end
      # return dispatch_driver
    end

    dispatch_driver.status = :UNAVAILABLE

    trip = Trip.new(
      id: dispatch_driver.id,
      passenger: find_passenger(passenger_id),
      passenger_id: passenger_id,
      start_time: Time.now,
      end_time: nil,
      cost: nil,
      rating: nil,
      driver: dispatch_driver,
      driver_id: dispatch_driver.id,
    )

    dispatch_driver.add_trip(trip)
    trip.passenger.add_trip(trip)
    @trips << trip
    return trip
  end

  private

  def connect_trips
    @trips.each do |trip|
      passenger = find_passenger(trip.passenger_id)
      driver = find_driver(trip.driver_id)
      trip.connect(passenger)
      trip.connect2(driver)
    end
    return trips
  end
end
