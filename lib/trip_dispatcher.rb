require 'csv'
require 'time'
require 'pry'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: './support')
      @passengers = Passenger.load_all(directory: directory)
      @drivers = Driver.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
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

      # Find first available driver
      counter = 0
      temp_status = self.drivers[counter].status
      binding.pry
      until temp_status == :AVAILABLE 
        temp_status = self.drivers[counter].status
        counter += 1
      end

      counter
      


      # Trip.new(
      #   id: Trip.last_trip + 1,
      #   passenger_id: passenger_id,
      #   driver_id: 1
      # )


    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        trip.connect(passenger)
        driver = find_driver(trip.driver_id)
        trip.connect_driver(driver)
      end

      return trips
    end
  end
end
