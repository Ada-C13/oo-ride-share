require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'
require_relative 'no_driver_error'


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
      # driver = @drivers.find {|driver|driver.status == :AVAILABLE}
      available_drivers = @drivers.select {|driver|driver.status == :AVAILABLE}
    
      driver = nil
      oldest_endtime = Time.now

      available_drivers.each do |indiv_driver|
        if indiv_driver.trips.length == 0
          driver = indiv_driver
        else 
          latest_trip = indiv_driver.trips.max_by {|trip| trip.end_time}
          if latest_trip.end_time < oldest_endtime 
            oldest_endtime = latest_trip.end_time  
            driver = indiv_driver
          end
        end
      end

      

      # avalable_drivers: use their id to look through trips
      # if id's are not found in trips, assign the ride
      # else find id with oldest end time and assign trip

      raise NoDriverError.new("Sorry! There are no available drivers. Please request a new trip.") if driver == nil

      start_time = Time.now
      end_time = nil
      rating = nil
      id = (601..100000).to_a.shift

      new_trip = Trip.new(id: id, passenger_id: passenger_id, start_time: start_time, end_time: end_time, rating: rating, driver: driver)
      @trips << new_trip
      
      passenger = @passengers.find {|passenger|passenger.id == passenger_id}

      new_trip.connect(passenger, driver)
      driver.make_driver_unavailable
      
      return new_trip
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
