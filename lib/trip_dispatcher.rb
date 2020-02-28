require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: './support')
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      @drivers = Driver.load_all(directory: directory)
      connect_trips
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    def find_driver(id)
      Driver.validate_id(id)
      return @drivers.find { |driver| driver.id == id}
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    def request_trip(passenger_id)
      passenger = self.find_passenger(passenger_id)
      trip_id = 601
      driver = find_driver_for_trip
      
      trip = RideShare::Trip.new(
        id: trip_id,
        passenger: passenger,
        passenger_id: passenger_id,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
        driver_id: driver.id,
        driver: driver
      )
      driver.change_driver_status
      driver.add_trip(trip)
      passenger.add_trip(trip)
      @trips << trip
      trip_id += 1
      return trip
    end

    def find_driver_for_trip

      available_drivers = self.drivers.select { |driver| driver.status == :AVAILABLE}

      if available_drivers.length == 0
        raise ArgumentError.new("There are no available drivers!")
      end

      available_drivers.each do |driver|
        if driver.trips.length == 0
          return driver
        end
      end

      available_drivers.sort! { |driver| driver.trips[-1].end_time}

      return available_drivers[-1]
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
