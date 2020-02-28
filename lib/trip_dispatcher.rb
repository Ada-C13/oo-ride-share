require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: './support')
      @passengers = Passenger.load_all(directory: directory)
      @drivers = Driver.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      @trip_count = 0
      connect_trips
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

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

    def request_trip(passenger_id)
      passenger = find_passenger(passenger_id)
      if !passenger
        return nil
      end

      avail_driver = nil
      @drivers.each do |driver|
        if driver.status == :AVAILABLE
          avail_driver = driver
          break
        end
      end

      if !avail_driver
        return nil
      end

      @trip_count += 1
      trip = RideShare::Trip.new(
        id: @trip_count,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
        driver: avail_driver,
        passenger: passenger
      )

      @trips << trip
      avail_driver.start_trip(trip)
      passenger.add_trip(trip)
      trip
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
