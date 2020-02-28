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


    # Helper method
    def available_drivers 
      # Select available drivers
      available_drivers = drivers.select do |driver|
        driver.status == :AVAILABLE
      end

      if available_drivers.empty? 
        raise ArgumentError.new("There are no available drivers")
      end 

      return available_drivers
    end  


    # Helper method
    def find_frist_driver     
      first_driver = nil

      available_drivers.each do |driver|
        if driver.trips.empty? # First choice  
          first_driver = driver
        end 
      end  

      if first_driver == nil 
        available_drivers.each do |driver|  
          driver.trips.sort_by! do |trip|
            trip.end_time
          end 
        end

        available_drivers.sort_by! do |driver|
          driver.trips[-1].end_time
        end 

        first_driver = available_drivers[0] # Second choice 
      end 

      return first_driver 
    end 
    
    
    def request_trip(passenger_id)

      available_driver = find_frist_driver

      connected_passenger = find_passenger(passenger_id)
      new_trip_id = @trips.length + 1

      new_trip = Trip.new(
        id: new_trip_id,
        passenger: connected_passenger,
        passenger_id: passenger_id,
        start_time: Time.now(),
        end_time: nil,
        cost: nil,
        rating: nil,
        driver: available_driver
      )

      # Update passenger and driver
      connected_passenger.add_trip(new_trip)
      available_driver.add_trip(new_trip)

      # Switch the status
      available_driver.switch_to_unavailable

      # Update trips
      @trips << new_trip
      return new_trip
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)
        trip.connect(passenger,driver)
      end

      return trips
    end
  end
end
