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
      @drivers = Driver.load_all(directory: directory) #Wave 2: added driver instance var
      connect_trips
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    #Wave 2: Loading Drivers- add find_driver
    def find_driver(id)
      Driver.validate_id(id)
      # return @drivers.find { |driver| driver.id == id }
      drivers.each do |driver|
        if driver.id == id
          return driver
        end
      end
      return nil
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    #Wave 3: Find driver_by_status
    def find_driver_status(status)
      Driver.validate_id(status)
      drivers.each do |driver|
        if driver.status == :AVAILABLE
          return driver
        end
      end
      return nil
    end

    #Wave 3: request_trip method
    #Wave 3: added new instance of trip
    def request_trip(passenger_id)
      new_driver = @driver.select {|driver| driver.status == :AVAILABLE}.first
      new_trip = Trip.new(     
        id: @trips.id[-1] + 1,
        driver: new_driver, 
        driver_id: new_driver.id, 
        passenger_id: passenger_id,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil
      )
      new_driver.add_trip(new_trip)
      new_driver.status = :UNAVAILABLE 
      passenger.find_passenger(passenger_id).add_trip(new_trip)
      connect_trips
      return trip
    end

    private

    #Wave 2: Updating the Trip to connect the driver
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
