require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'

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
      return @drivers.find{ |driver| driver.id == id }
    end

    def request_trip(passenger_id)
      #give an instance of passenger 
      found_passenger = @passengers.find do |passenger|
        passenger.id == passenger_id
      end
      p_id = found_passenger.id

      #choose the first driver with available status to the passenger 
      available_driver = @drivers.find do |driver|
        driver.status == :AVAILABLE 
      end 
      d_id = available_driver.id
      #current time should be start time 
      current_time = Time.now 

      # create a unique trip id 
      unique_trip_id = @trips.last.id + 1
      
      #the end date, cost, and rating wil be nil 
      in_progress_trip = Trip.new(id: unique_trip_id, passenger: found_passenger, passenger_id: p_id, driver: available_driver, driver_id: d_id, start_time: current_time)

# avail_dri.status == AVAIL

      #available_driver.status = :UNAVAILABLE #TODO ask to see what helper method they're talking about 

      available_driver.switch_status

      # avail_dri.status == ???

      available_driver.add_trip(in_progress_trip)
      found_passenger.add_trip(in_progress_trip)
      @trips << in_progress_trip

      return in_progress_trip
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
        trip.connect(passenger)
        trip.connect_driver(driver)
      end

      return trips
    end
  end
end
