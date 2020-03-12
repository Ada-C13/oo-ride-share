require "csv"
require "time"
require_relative "csv_record"

module RideShare
  class Trip < CsvRecord
    attr_reader :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver_id, :driver

    def initialize(
      id:,
      passenger: nil,
      passenger_id: nil,
      start_time:,
      end_time:,
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
        raise ArgumentError, "Passenger or passenger_id is required"
      end

      if driver
        @driver = driver
        @driver_id = driver.id
      elsif driver_id
        @driver_id = driver_id
      else
        raise ArgumentError, "Driver or driver_id is required"
      end

      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating

      if @rating && (@rating > 5 || @rating < 1)
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if @end_time != nil
        raise ArgumentError.new("The start time should be before the end time") if @end_time < @start_time
      end
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
        "ID=#{id.inspect} " +
        "PassengerID=#{passenger&.id.inspect}>"
    end

    def connect(passenger, driver)
      @passenger = passenger
      passenger.add_trip(self)
      @driver = driver
      driver.add_trip(self)
    end

    def duration
      return end_time - start_time
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
               rating: record[:rating],
             )
    end
  end
end
