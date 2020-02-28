require 'csv'
require 'time'
require_relative 'csv_record'

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
          rating: ,
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

      if start_time > end_time # added ArgumentError if start time is greater
        raise ArgumentError, 'Start time cannot be greater than end time'
      end
     

      @start_time = start_time
      @end_time = end_time

      @cost = cost
      @rating = rating

      if driver
        @driver = driver
        @driver_id = driver.id

      elsif driver_id
        @driver_id = driver_id

      else 
        raise ArgumentError, 'Driver or driver_id is required'
      end

      if @rating > 5 || @rating < 1
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

    def connect(passenger)
      @passenger = passenger
      passenger.add_trip(self)
    end

    def duration_in_seconds  # the duration of a trip
     return @end_time - @start_time # end time minus start time in seconds
    
    end


    private

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               driver_id: record[:driver_id],
               passenger_id: record[:passenger_id],
               start_time: Time.parse(record[:start_time]).utc, # addedd Time.parse and utc to change the time from csv 
               end_time: Time.parse(record[:end_time]).utc, #style which is a string to give us time object
               cost: record[:cost],
               rating: record[:rating]
               
             )
    end

  end
end
