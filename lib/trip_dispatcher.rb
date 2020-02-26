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
      return @drivers.find { |driver| driver.id == id }
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    def pick_driver_for_trip
      available_drivers = @drivers.select{ |driver| driver.status == :AVAILABLE}
      raise "No drivers are currently available" if available_drivers.length == 0

      picked_driver = ""
      oldest_end_time = Time.now

      available_drivers.each do |driver|
        if driver.trips.length == 0
          picked_driver = driver
          return picked_driver
        else
          driver_most_recent_end_time = driver.trips.max_by { |trip| trip.end_time }.end_time
          if driver_most_recent_end_time < oldest_end_time
            oldest_end_time = driver_most_recent_end_time
            picked_driver = driver
          end
        end
      end

      return picked_driver
    end

    def request_trip(passenger_id)

      found_passenger = find_passenger(passenger_id)
      available_driver = pick_driver_for_trip
      new_trip = Trip.new(id: @trips.length + 1, passenger: found_passenger, start_time: Time.now, end_time: nil, cost: nil, rating: nil, driver_id: available_driver.id, driver: available_driver)

      available_driver.trip_in_progress(new_trip)
      found_passenger.add_trip(new_trip)
      @trips.push(new_trip)

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
