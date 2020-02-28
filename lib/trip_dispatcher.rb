require "csv"
require "time"

require_relative "passenger"
require_relative "trip"
require_relative "driver"

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: "./support")
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      @drivers = Driver.load_all(directory: directory)
      connect_trips
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      passenger = @passengers.find { |passenger| passenger.id == id }
      return passenger
    end

    def find_driver(id)
      Driver.validate_id(id)
      return @drivers.find { |driver| driver.id == id }
    end

    def request_trip(passenger_id)
      available_driver = @drivers.find { |driver| driver.status == :AVAILABLE }
      puts "#{available_driver}"
      new_trip = RideShare::Trip.new(
        id: @trips.last.id + 1,
        passenger: find_passenger(passenger_id),
        passenger_id: passenger_id,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
        driver_id: available_driver.id,
        driver: available_driver,
      )

      raise ArgumentError.new("There are no drivers available") if driver == nil
      driver.status = :UNAVAILABLE
      @trips << new_trip
      new_trip.connect(passenger, driver)
      return new_trip
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)
        trip.connect(passenger, driver)
      end
      return trips
    end
  end
end
