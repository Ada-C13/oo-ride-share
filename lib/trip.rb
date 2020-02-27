require "csv"
require "time"

require_relative "csv_record"

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver, :driver_id

    def initialize(
          id:,
          passenger: nil,
          passenger_id: nil,
          start_time:,
          end_time:,
          cost: nil,
          rating:,
          driver: nil,
          driver_id: nil
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

      # Wave 2: When a Trip is constructed, either driver_id or driver must be provided.
      if driver
        @driver = driver
        @driver_id = driver.id
      elsif driver_id
        @driver_id = driver_id
      else
        raise ArgumentError, 'Driver or driver_id is required'
      end

      # Raises an ArgumentError if the end time is before the start time
      if end_time > start_time
        @start_time = start_time
        @end_time = end_time
      else
        raise ArgumentError, 'Those are invalid times'
      end
      

      @cost = cost
      @rating = rating

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end

    # Wave 1: Add an instance method to the Trip class to calculate the duration of the trip in seconds
    def calculate_duration
      duration = @end_time - @start_time
      return duration
    end

    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
        "ID=#{id.inspect} " +
        "PassengerID=#{passenger&.id.inspect}>"
    end

    def connect(passenger)
      @passenger = passenger
      passenger.add_trip(self)
    end

    def connect2(driver)
      @driver = driver
      driver.add_trip(self)
    end


    private

    # Wave 1: Turn start_time and end_time into Time instances before passing them to Trip#initialize
    # Trip.from_csv overrides CsvRecord.from_csv
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
