require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'driver'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    # loads the data from passenger csv and trips csv
    def initialize(directory: './support')
      @drivers = Driver.load_all(directory: directory)
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
      return @drivers.find { |driver| driver.id == id }
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    def request_trip(passenger_id)
      @passenger_id = passenger_id
      # initialize trip dispatcher
      # then we can use csv to pull from passenger, to get info
      # where we can get name, phone_number
      # also get driver data

      # sort of similar to this id
      # def self.find(id)
      #   orders = Order.all
      #   found_order = orders.detect {|order| (order.id) == id}
      #   return found_order
      # end


      # drivers.each.do |trip|
      #   connect_trips
      # end 


      # @trip_data = {
      #   id: 8,
      #   # passenger: RideShare::Passenger.new(
      #   #   id: 1,
      #   #   name: "Ada",
      #   #   phone_number: "412-432-7640"
      #   # ),
      #   # driver: RideShare::Driver.new(
      #   #   id: 54,
      #   #   name: "Test Driver",
      #   #   vin: "12345678901234567",
      #   #   status: :AVAILABLE
      #   # ),
      #   passenger = find_passenger(trip.passenger_id),
      #   driver: find_driver(trip.driver_id),
      #   start_time: Time.now,
      #   end_time: nil,
      #   cost: nil,
      #   rating: nil
      # }
      # RideShare::Trip.new(@trip_data)
    end

    private

    # matches passenger csv and trip csv
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
