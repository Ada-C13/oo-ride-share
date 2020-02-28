require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: './support')
      @passengers = Passenger.load_all(directory: directory) # an Array of Passenger
      @trips      = Trip.load_all(directory: directory) # an Array of Trip
      @drivers    = Driver.load_all(directory: directory) # an Array of Driver
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
      raise ArgumentError, "Passenger id not found" if passenger == nil

      driver = @drivers.select {|driver| driver.status == :AVAILABLE}.first
      raise ArgumentError, "There are no drivers available" if driver == nil
      new_id = @trips.map { |trip| trip.id }.max + 1 # in case trips are not sorted by id

      trip = Trip.new(id: new_id, passenger: passenger, driver: driver)
      
      driver.status = :UNAVAILABLE
      trip.connect(passenger, driver) # add trip to passenger trips and driver trips
      @trips << trip # add trip to dispatcher trips
      # driver.add_trip(trip) # trip.connect already does this
      # passenger.add_trip(trip) # trip.connect already does this
      # do not use connect_trips, this is only when loading the CSV
      return trip
    end
    
    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver    = find_driver(trip.driver_id)
        trip.connect(passenger, driver)
      end
      return trips
    end
  end
end


