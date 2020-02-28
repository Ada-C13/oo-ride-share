require 'csv'
require 'time'

require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver_id, :driver

    def initialize(
          id:,
          passenger: nil,
          passenger_id: nil,
          start_time: Time.now,
          end_time: nil,
          cost: nil,
          rating: nil,
          driver_id: nil,
          driver: nil
        )
      super(id)
      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating

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

      if start_time.class != Time
        raise ArgumentError.new("Value is not a Time object.")
      end

      if @rating == nil
        @rating = rating
      elsif @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
  
      unless @end_time == nil
        if @end_time < @start_time
          raise ArgumentError.new('End time cannot be before start time.')
        end
      end
    end

    def time_difference
      if @end_time == nil || @start_time == nil
        raise ArgumentError.new("Start time or end time cannot be nil.")
      end 

      return @end_time - @start_time
    end
  

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
        "ID=#{id.inspect} " +
        "PassengerID=#{passenger&.id.inspect}>"
    end

    def connect_passenger(passenger)
      @passenger = passenger
      passenger.add_trip(self)
    end

    def connect_driver(driver)
      @driver = driver
      driver.add_trip(self)
    end

    private

    def self.from_csv(record)
      return new(
               id: record[:id],
               passenger_id: record[:passenger_id],
               start_time: Time.parse(record[:start_time]),
               end_time: Time.parse(record[:end_time]),
               cost: record[:cost],
               rating: record[:rating],
               driver_id: record[:driver_id]
             )
    end
  end
end