require 'csv'
require 'time'
require 'awesome_print'
require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :driver, :driver_id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating

    def initialize(
      id:,
      driver: nil, #Wave 2: addin Driver instance for this trip
      driver_id: nil, #Wave 2: adding id of the driver for this trip
      passenger: nil,
      passenger_id: nil,
      start_time:,
      end_time:,
      cost: nil,
      rating:
      )
      super(id)

      if passenger
        @passenger = passenger
        @passenger_id = passenger.id
      elsif passenger_id
        @passenger_id = passenger_id
      else
        raise ArgumentError, 'Passenger or passenger_id is required'
      end

      #Wave 2: Updating Trip
      #When a Trip is constructed, either driver_id or driver must be provided.
      if driver
        @driver = driver
        @driver_id = driver.id
      elsif driver_id
        @driver_id = driver_id
      else
        raise ArgumentError, 'Driver or driver_id is required'
      end

      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
      
      #Wave 1.1 #3: Adding check for raising argument 
      if start_time > end_time #https://ruby-doc.org/core-2.6.3/Time.html
        raise ArgumentError.new("Invalid, start time must be before end time")
      end

    end

    #Wave 1:1 4.Adding duration of the trip in seconds
    def duration()
      return (end_time - start_time) #will return in seconds because Time class method
    end

    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
        "ID=#{id.inspect} " +
        "PassengerID=#{passenger ? passenger.id.inspect : passenger_id}>"
    end

    #Wave 2: Loading Driver: Adding driver to connect 
    def connect(passenger, driver)
      @passenger = passenger
      passenger.add_trip(self)
      @driver = driver
      driver.add_trip(self)
    end

    private

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               driver_id: record[:driver_id],
               passenger_id: record[:passenger_id],
               start_time: Time.parse(record[:start_time]),
               end_time: Time.parse(record[:end_time]),
               cost: record[:cost],
               rating: record[:rating]
             )
    end
  end
end

# trips =RideShare::Trip.load_all(full_path: 'support/trips.csv')
# ap trips
# require "pry"
# binding.pry