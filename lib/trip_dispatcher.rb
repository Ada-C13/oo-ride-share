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
      return @drivers.find {|driver| driver.id == id}
    end 

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    def request_trip(passenger_id)
      #pass passenger_id to find_passenger method
      new_passenger = find_passenger(passenger_id)

      #find available driver
      new_driver = @drivers.find { |driver| driver.status == :AVAILABLE  }
      #Create trip object:
        #set start time to current time, end time, cost, rating to nil
      trip_id = @trips.last.id + 1
     
      new_trip = Trip.new(id: trip_id, driver_id: new_driver.id, passenger_id: new_passenger.id, start_time: Time.now, end_time: nil, rating: nil)

      #using new helper method in Driver, set that driver to unavailable now
      new_driver.change_status
      #add Trip to the passnger's lsit of Trips
      new_passenger.add_trip(new_trip)
      #add trip to trip dispatcher array
      @trips << new_trip
      #return newly created trip
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
