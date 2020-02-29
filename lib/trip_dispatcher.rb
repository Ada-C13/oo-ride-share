require "csv"
require "time"
# require 'pry'

require_relative "passenger"
require_relative "trip"
require_relative "driver"

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips, :drivers

    def initialize(directory: "./support")
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      # Wave 2: load Drivers
      @drivers = Driver.load_all(directory: directory)
      connect_trips
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    # find driver
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

    def find_available_drivers
      available_drivers = []

      @drivers.each do |driver|
        if driver.status == :AVAILABLE
          available_drivers << driver
        end
      end
      return available_drivers
    end

    # Wave 3
    # creates a trip and assigns an available driver
    def request_trip(passenger_id)
      # available_drivers = []

      # @drivers.each do |driver|
      #   if driver.status == :AVAILABLE
      #     available_drivers << driver
      #   end
      # end

      
      dispatch_driver = find_available_drivers

      if dispatch_driver.length == 0
        raise ArgumentError.new("No available drivers")
      end

      trip = Trip.new(
        id: @trips.last.id + 1,
        passenger: find_passenger(passenger_id),
        passenger_id: passenger_id,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
        driver: dispatch_driver[0],
        driver_id: dispatch_driver[0].id,
      )

      dispatch_driver[0].add_trip(trip)
      dispatch_driver[0].status = :UNAVAILABLE
      trip.passenger.add_trip(trip)

      @trips << trip
      trip.connect(trip.passenger)
      trip.connect_driver(dispatch_driver[0])

      return trip
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

# Wave 3 TripDispatcher tests:

# Was the trip created properly?
# Were the trip lists for the driver and passenger updated?
# Was the driver who was selected AVAILABLE?
# What happens if you try to request a trip when there are no AVAILABLE drivers?

# Interaction with Waves 1 & 2
# One thing you may notice is that this change breaks your code from previous waves, possibly in subtle ways. We've added a new kind of trip, an in-progress trip, that is missing some of the values you need to compute those numbers.

# Your code from waves 1 & 2 should ignore any in-progress trips. That is to say, any trip where the end time is nil should not be included in your totals.

# You should also add explicit tests for this new situation. For example, what happens if you attempt to calculate the total money spent for a Passenger with an in-progress trip, or the average rating of a Driver with an in-progress trip?
