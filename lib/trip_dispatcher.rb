require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'

# can't call from_csv because privately declared in CsvRecord (Passenger and Trip can call this though)

module RideShare
  class TripDispatcher 
    attr_accessor :trips, :drivers, :passengers

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

    def get_first_available
      @drivers.each do |driver|
        p driver
        if driver.status == :AVAILABLE
          driver.status = :UNAVAILABLE
          return driver
        end
      end 
    end 

    def request_trip(passenger_id)
    passenger_from_id = find_passenger(passenger_id)
    driver_available = get_first_available
    trip1 = Trip.new(
    id: (@trips.last.id)+1,
    driver_id: (driver_available.id),
    driver: driver_available,
    passenger: passenger_from_id,
    passenger_id: passenger_id,
    start_time: Time.now,
    end_time: nil,
    cost: nil,
    rating: nil
    )
    passenger_from_id.trips.push trip1
    trips.push trip1
    driver_available.add_requested_trip(trip1)

    return trip1
    end

    # Add the new trip to the collection of trips for that Driver

    private

    #Dispatcher.connect_trips is not allowed by external code, only TripDispatcher can call it on itself.

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)
        trip.connect(passenger, driver)
      end
      # return trips or @trips?
      return trips
    end

  end
end
