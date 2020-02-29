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

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    def request_trip(passenger_id)
      passenger_object = @passengers.find {|passenger| passenger_id == passenger_id}

      first_available_driver = @drivers.find{|driver| driver.status == :AVAILABLE}
      end_time = nil
      cost = nil

      new_trip = Trip.new(
        id: @trips.length + 1,
        passenger: passenger_object,
        passenger_id: nil,
        start_time: Time.new,
        end_time: nil,
        cost: nil,
        rating: nil,
        driver: first_available_driver,
        driver_id: nil
      )

      first_available_driver.add_trip(new_trip)
      # first_available_driver.status = :UNAVAILABLE
      first_available_driver.flip_status


      passenger_object.add_trip(new_trip)
      
      @trips << new_trip
      return new_trip

    end

    def find_driver(driver_id)
      found_driver = @drivers.find {|driver| driver.id == driver_id}

      if found_driver == nil
        raise ArgumentError, "No driver with id: #{driver_id} found"
      else
        return found_driver
      end
    end

    private

    def connect_trips
      @trips.each do |trip|
        driver = find_driver(trip.driver_id)
        passenger = find_passenger(trip.passenger_id)
        trip.connect(passenger, driver)
      end
      return trips
    end
  end
end
