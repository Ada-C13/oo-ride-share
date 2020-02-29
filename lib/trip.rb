require 'csv'
require 'time'
require_relative 'csv_record'
# Trip inherits from CsvRecord
module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver, :driver_id

    # Initialize new trip
    def initialize(
          id:,
          passenger: nil,
          passenger_id: nil,
          start_time: nil,
          end_time: nil,
          cost: nil,
          rating: nil,
          driver_id: nil,
          driver: nil
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

      if driver
        @driver = driver
        @driver_id = driver.id
      elsif driver_id
        @driver_id = driver_id
      else
        raise ArgumentError, 'Driver or driver_id is required'
      end

      # if the trip is NOT in progress, we test for compatible start and end times
      if !(start_time.class == Time && end_time == nil) && end_time < start_time
        raise ArgumentError.new("Incompatible start and end times")
      end

      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating

      # if the trip is NOT in progress, we test for a valid rating
      if @rating != nil && (@rating > 5 || @rating < 1)
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end

    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
        "ID=#{id.inspect} " +
        "PassengerID=#{passenger&.id.inspect}>"
    end
    
    # Add trip to corresponding passenger and driver
    def connect(passenger, driver)
      @passenger = passenger
      passenger.add_trip(self)
      @driver = driver
      driver.add_trip(self)
    end
    
    # Calculate trip's duration in seconds
    def duration
      # TODO: make sure this case handling for trip in prgress fits specs
      if end_time == nil
        return 0
      end
      start_in_sec = (@start_time.hour * 3600) + (@start_time.min * 60) + @start_time.sec
      end_in_sec = (@end_time.hour * 3600) + (@end_time.min * 60) + @end_time.sec
      return end_in_sec - start_in_sec
    end

    private

    def self.from_csv(record)
      end_time = Time.parse(record[:end_time])
      start_time = Time.parse(record[:start_time])
      return self.new(
               id: record[:id],
               passenger_id: record[:passenger_id],
               start_time: start_time,
               end_time: end_time,
               cost: record[:cost],
               rating: record[:rating],
               driver_id: record[:driver_id]
             )
    end
  end
end
