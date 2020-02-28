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
 
    def find_available_drivers
      available_drivers = @drivers.select do |driver|
        driver.status == :AVAILABLE
      end

      return available_drivers
    end

    def select_driver(available_drivers)
      available_drivers.each do |driver|
        if driver.trips.length == 0
          return driver
        end
      end
      
      available_drivers.each do |driver|
        driver.trips.sort_by! do |trip|
          trip.end_time
        end
      end

      available_drivers.sort_by! do |driver|
        driver.trips.last.end_time
      end

      return available_drivers.first
    end

    def request_trip(passenger_id)
      # Find list of available drivers.
      available_drivers = find_available_drivers

      # If no available drivers are found
      if available_drivers.length == 0
        raise ArgumentError.new("No available drivers!")
      end

      # Find a driver with no trips ever or the oldest trip.
      available_driver = select_driver(available_drivers)

      current_passenger = find_passenger(passenger_id)

      id = trips.length + 1
      
      new_trip = RideShare::Trip.new(
        id: id, 
        passenger_id: passenger_id, 
        start_time: Time.now, 
        end_time: nil, 
        cost: nil, 
        rating: nil, 
        driver: available_driver
      )

      available_driver.update_status(new_trip) # Updates driver status to unavailable.
      current_passenger.add_trip(new_trip) # Adds current trip to current passenger's list of trips.
      @trips << new_trip # Adds current trip to list of all trips in system.

      return new_trip
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
        trip.connect(passenger, driver)
      end

      return trips
    end
  end
end
