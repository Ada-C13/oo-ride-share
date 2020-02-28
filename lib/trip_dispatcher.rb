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
      raise ArgumentError, "Pasanger id not founded" if passenger == nil
      driver = @drivers.select {|driver| driver.status == :AVAILABLE}.first
      raise ArgumentError, "There are not available" if driver == nil
      
      # driver = ""
      # @drivers.each do |driver|
      #   if driver.status == :AVAILABLE
          # trip.connect(passenger,driver)
      #   break
      #   end  
      # end
      new_trip = Trip.new(
        id: @trips.length + 1,
        driver: driver,
        passenger: passenger,
        start_time: Time.now, 
        end_time: nil,
        cost: nil,
        rating: nil
    )

      new_trip.connect(passenger,driver)

      driver.update_status


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
