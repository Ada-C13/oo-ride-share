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
    
    def find_available_driver
      available_driver = @drivers.select { |driver| driver.status == :AVAILABLE }[0]

      return available_driver
    end

    def request_trip(passenger_id)
      @driver = find_available_driver

      new_trip = RideShare::Trip.new(
        #TODO: Sort @trips by id first
        id: @trips.last.id + 1,
        driver: @driver,
        passenger_id: passenger_id,
        start_time: Time.now,
        rating: nil 
      )
      @driver.add_trip(new_trip)
      @driver.modify_status
      # add to passenger's collection of trips (use current trip passenger id)

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

# for each trip in the collection of trips, look at the individual trip
# passenger = that trip's passenger id passed to find_passenger, which returns a passenger object with the matching id