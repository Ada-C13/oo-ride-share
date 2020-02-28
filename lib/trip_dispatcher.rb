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
      available_driver = @drivers.select {|driver| driver.status == :AVAILABLE}.first
      passenger = self.find_passenger(passenger_id)

      #Wave 3: .find_pass is in THIS class, need to call self not passenger
      #Error checking in case of bad data:
      # checks is there's a passenger and driver, if yes, connect trip.
      # if no, no trip.
      if (passenger != nil)  && (available_driver != nil)
        new_trip = Trip.new(     
          id: @trips[-1].id + 1, #fixed accessing this last trip in array then access id
          driver: available_driver, 
          driver_id: available_driver.id, 
          passenger: passenger, #adding this back in to use
          passenger_id: passenger_id,
          start_time: Time.now,
          end_time: nil,
          cost: nil,
          rating: nil
        )
        available_driver.add_trip(new_trip)
        available_driver.status = :UNAVAILABLE 
        passenger.add_trip(new_trip)
        connect_trips
        return new_trip
      else
        return nil #if there's no passenger and driver, return nil
      end
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
