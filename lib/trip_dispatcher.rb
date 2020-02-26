require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'

# can't call from_csv because privately declared in CsvRecord (Passenger and Trip can call this though)

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: './support')
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      connect_trips
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    def find_driver(id)
      Driver.validate_id(id)
      return @drivers.find { |passenger| passenger.id == id }
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    private

    #Dispatcher.connect_trips is not allowed by external code, only TripDispatcher can call it on itself.

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        trip.connect(passenger)
      end
      # return trips or @trips?
      return trips
    end
  end
end
