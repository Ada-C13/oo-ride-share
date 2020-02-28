require 'csv'
require 'time'
require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :driver, :driver_id, :start_time, :end_time, :cost, :rating

    def initialize(
          id:,
          passenger: nil,
          passenger_id: nil,
          driver: nil,
          driver_id: nil,
          start_time:,
          end_time:,
          cost: nil,
          rating: nil
        )
      super(id)

      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating
      

      # Handling nil and edge cases for attributes
      if passenger
        @passenger = passenger
        @passenger_id = passenger_id
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

      if @rating.nil? == true
        @rating = @rating
      elsif @rating <= 5 && @rating >= 1
        @rating = @rating
      else @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      # 1.1 ArgumentError for end time < start time
      if @end_time.nil? == true
        @end_time = @end_time
      elsif @start_time.nil? == true
        @start_time = @start_time
      elsif @end_time >= @start_time
        @end_time = @end_time
        @start_time = @start_time
      else @end_time < @start_time
        raise ArgumentError.new("Cannot have an end time before a start time.")
      end
    end

    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
        "ID=#{id.inspect} " +
        "PassengerID=#{passenger&.id.inspect}>"
    end

    def connect(passenger, driver)
      @passenger = passenger
      @driver = driver
      passenger.add_trip(self)
      driver.add_trip(self)
    end

    # 1.1 #4 instance method of duration of trip
    def duration
      return (Time.parse(@end_time) - Time.parse(@start_time)).to_i
    end

    private

    # overrides the .from_csv in csv_record
    def self.from_csv(record)
      return self.new(
               id: record[:id],
               passenger_id: record[:passenger_id],
               driver_id: record[:driver_id],
               start_time: Time.parse(record[:start_time]),
               end_time: Time.parse(record[:end_time]),
               cost: record[:cost],
               rating: record[:rating]
             )
    end
  end
end
