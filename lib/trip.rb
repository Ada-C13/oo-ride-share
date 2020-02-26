require 'csv'
require 'time'
require 'driver'

require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id,:driver, :driver_id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating

    def initialize(
          id:,
          driver: nil,
          driver_id: nil,
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

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if @start_time > @end_time
        raise ArgumentError, "Start time is later than end time. Start: #{@start_time}, End: #{@end_time}"
      end
    end

    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
        "ID=#{id.inspect} " +
        "PassengerID=#{passenger&.id.inspect}>"
    end

    def connect(passenger,driver)
      @passenger = passenger
      @driver = driver
      driver.add_trip(self)
      passenger.add_trip(self)
    end




    def duration
      return @end_time - @start_time
    end 

    private

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               passenger_id: record[:passenger_id],
               start_time: record[Time.parse(:start_time)],
               end_time: record[Time.parse(:end_time)],
               cost: record[:cost],
               rating: record[:rating]
             )
    end
  end
end
