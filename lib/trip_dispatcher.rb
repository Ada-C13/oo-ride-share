require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: './support')
      @drivers = Driver.load_all(directory: directory)
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
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

    def find_available_driver 
      all_available_drivers = []
      drivers.each do |driver|
        if driver.status = :AVAILABLE && driver.ongoing_trip.length == 0
          all_available_drivers << driver
        end
      end

      if all_available_drivers.empty?
        raise ArgumentError.new "There are no available drivers at this time"
      end

      return all_available_drivers.shuffle[0]
    end

    def start_trip(driver:, passenger:)
      current_time = Time.new
      new_id = (trips.last.id + 1)
      return Trip.new(id: new_id, passenger: passenger, driver: driver, start_time: current_time)
    end

    def request_trip(passenger_id)
      available_driver = self.find_available_driver
      passenger = self.find_passenger(passenger_id)

      new_trip = self.start_trip(driver: available_driver, passenger: passenger)

      available_driver.assign_new_trip(new_trip)
      passenger.add_trip(new_trip)
      trips <<  new_trip

      return new_trip
    end


    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        trip.connect_passenger(passenger)
        trip.connect_driver(find_driver(trip.driver_id))
      end

      return trips
    end
  end
end
