require 'csv'

require_relative 'csv_record'
require_relative 'driver'
require_relative 'passenger'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver_id, :driver

    def initialize(
          id:,
          passenger: nil,
          passenger_id: nil,
          driver_id: nil,
          driver: nil,
          start_time:,
          end_time:,
          cost: nil,
          rating:
        )
      super(id)

      if driver
        @driver = driver
        @driver_id = driver.id

      elsif driver_id
        @driver_id = driver_id

      else
        raise ArgumentError, 'Driver or driver_id is required'
      end

      if passenger
        @passenger = passenger
        @passenger_id = passenger.id

      elsif passenger_id
        @passenger_id = passenger_id

      else
        raise ArgumentError, 'Passenger or passenger_id is required'
      end

      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating

      valid_ratings = [1, 2, 3, 4, 5, nil]

      unless valid_ratings.include?(@rating)
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if end_time != nil
        if @end_time - @start_time < 0
          raise ArgumentError.new("End time: #{@end_time} cannot be less than start time: #{@start_time}")
        end
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

    def duration
      return @end_time - @start_time
    end

    private

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
