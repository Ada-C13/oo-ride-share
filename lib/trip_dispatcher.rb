require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'driver'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: './support')
      @passengers = Passenger.load_all(directory: directory)
      @drivers = Driver.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      @trip_id = 601
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
      driver_available = find_available_driver
      current_trip = Trip.new(id: @trip_id, 
        passenger_id: passenger_id, 
        start_time: Time.now(), 
        end_time: nil, 
        cost: nil, 
        rating: nil, 
        driver: driver_available)
      #driver 
      driver_available.add_trip(current_trip)
      #passenger 
      passenger_object = find_passenger(passenger_id)
      passenger_object.add_trip(current_trip)
      @trip_id +=1
      driver_available.status = :UNAVAILABLE
      @trips << current_trip
      return current_trip
    end 


    def find_available_driver
      
      @drivers.each do |driver|
        if driver.status == :AVAILABLE
          return driver 
        end 
      end 
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
