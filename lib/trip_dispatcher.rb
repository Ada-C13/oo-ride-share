require 'csv'
require 'time'
require 'pry'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: './support')
      @passengers = Passenger.load_all(directory: directory)
      @drivers = Driver.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
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

    def first_available_driver
      counter = nil
      max_time = Time.now()
      self.drivers.each_with_index do |driver, index|
        if driver.status == :AVAILABLE 
          return index if driver.trips.length == 0

          if driver.trips.last.end_time < max_time
            max_time = driver.trips.last.end_time
            counter = index
          end
        end
      end
      raise ArgumentError, "There is no available driver!" if nil == counter 

      return counter
    end


    def request_trip(passenger_id)

      counter = first_available_driver 

      # Change driver status
      self.drivers[counter].change_status()

      # Create new trip 
      new_trip = Trip.new(
        id: self.trips.last.id + 1,
        passenger_id: passenger_id,
        driver_id: self.drivers[counter].id,
        start_time: Time.now
      )

      # Add new trip to driver and passenger
      new_trip.connect(find_passenger(passenger_id),self.drivers[counter])
      @trips << new_trip
      return new_trip
    end

    private

    def connect_trips
      @trips.each do |trip|
        trip.connect(find_passenger(trip.passenger_id),find_driver(trip.driver_id))
      end

      return trips
    end
  end
end
