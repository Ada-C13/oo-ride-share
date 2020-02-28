require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: './support')
      @passengers = Passenger.load_all(directory: directory) 
      @trips      = Trip.load_all(directory: directory) 
      @drivers    = Driver.load_all(directory: directory)
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
      new_id = @trips.map { |trip| trip.id }.max + 1    # in case trips are not sorted by id

      trip = Trip.new(id: new_id, passenger: passenger, driver: driver)
      
      driver.status = :UNAVAILABLE
      trip.connect(passenger, driver) 
      @trips << trip 
      return trip
    end
    
    def request_trip_optimized(passenger_id)
      passenger = find_passenger(passenger_id)
      raise ArgumentError, "Passenger id not found" if passenger == nil

      driver = find_optimal_driver      # helper function to find the driver
      raise ArgumentError, "There are no drivers available" if driver == nil
      new_id = @trips.map { |trip| trip.id }.max + 1    # in case trips are not sorted by id

      trip = Trip.new(id: new_id, passenger: passenger, driver: driver)
      
      driver.status = :UNAVAILABLE
      trip.connect(passenger, driver) 
      @trips << trip 
      return trip
    end
 
    def find_optimal_driver
      available = @drivers.select { |driver| driver.status == :AVAILABLE }
      not_inprogress = available.select { |driver| in_progress(driver.trips) == nil } 
      return not_inprogress.first if not_inprogress.size <= 1 

      never_driven = not_inprogress.select { |driver| driver.trips.size == 0 } 
      return never_driven.first if never_driven.size > 0 

      sorted_drivers = not_inprogress.sort_by { |driver| recent_end_time(driver.trips) }     # sort drivers by end_time of most recent trip
      return sorted_drivers.first 
    end

    # Helper Method to Find In Progress Trips in an Array of Trips
    def in_progress(trips)
      return trips.find { |trip| trip.end_time == nil } # nil if no in progress trip, otherwise that trip
    end

    # Helper Method to Find the End Time of the Most Recent Trip in an Array of Trips
    def recent_end_time(trips)
      return trips.sort_by { |trip| trip.end_time }.last.end_time 
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


