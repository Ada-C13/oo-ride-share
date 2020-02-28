require 'csv'
require 'time'
require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'

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

    def get_longest_ago(available_drivers_list)
      longest_ago = Time.now
      best_driver = nil
      available_drivers_list.each do |driver|
      # Pick first driver in array of available drivers that has nil or no trips
        if driver.trips == nil || driver.trips == []
          best_driver = driver
          driver.status = :UNAVAILABLE
          return best_driver
        else 
          driver.trips.each do |trip|
            if trip.end_time.to_i < longest_ago.to_i
              longest_ago = trip.end_time
              best_driver = driver
            end
          end
        end 
      end
      best_driver.status = :UNAVAILABLE
      return best_driver
    end

    def available_drivers
      available_drivers_list = []
      @drivers.each do |driver|
        if driver.status == :AVAILABLE && (driver.trips.each { |trip| trip.end_time != nil })
          available_drivers_list << driver
        end
      end 
      return available_drivers_list
    end 

    def request_trip(passenger_id)
      passenger_from_id = find_passenger(passenger_id)
      available_drivers_list = available_drivers
      best_driver = get_longest_ago(available_drivers_list)
      trip1 = Trip.new(
                      id: (@trips.last.id)+1,
                      driver_id: (best_driver.id),
                      driver: best_driver,
                      passenger: passenger_from_id,
                      passenger_id: passenger_id,
                      start_time: Time.now,
                      end_time: nil,
                      cost: nil,
                      rating: nil
      )
      passenger_from_id.trips.push(trip1)
      trips.push(trip1)
      # WHY best_driver.add_requested_trip and return trip1?
      best_driver.add_requested_trip(trip1)
      return trip1
    end

    private

    # Dispatcher.connect_trips is not allowed by external code, only TripDispatcher can call it on itself.
    # Should we add/change tests for this method to account for driver and passenger together?
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
