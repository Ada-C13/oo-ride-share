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
      available_driver = nil

      @trips.each do |trip|
        if trip.driver.status == :AVAILABLE
          available_driver = trip.driver.id
          trip.driver.status = :UNAVAILABLE
        end
      end
      # first_driver = @trips.select do |trip|
      #   trip.driver.status == :AVAILABLE
      # end
      new_trip_id = @trips.length

      new_trip = Trip.new(
        id: new_trip_id,
        passenger: find_passenger(passenger_id),
        passenger_id: passenger_id,
        start_time: Time.now(),
        end_time:nil,
        cost: nil,
        rating:nil,
        driver_id: available_driver,
        driver: find_driver(available_driver)
      )
      Passenger.new(
        id: passenger_id,
        name: find_passenger(passenger_id).name,
        phone_number:find_passenger(passenger_id).phone_num
      )
      passenger.add_trip(new_trip)

      CSV.open("trips.csv","a") do |csv|
        csv << [new_trip.id, new_trip.driver_id, new_trip.passenger_id, new_trip.start_time,
          new_trip.end_time, new_trip.cost, new_trip.rating]
      end
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
