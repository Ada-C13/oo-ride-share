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
          end_time: nil,
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

      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating
      # @driver = driver
      # @driver_id = driver_id

      if driver
        @driver = driver
        @driver_id = driver.id
      elsif driver_id
        @driver_id = driver_id
      else
        raise ArgumentError, 'Driver or driver_id is required'
      end

      raise ArgumentError if @end_time < @start_time unless end_time == nil
      raise ArgumentError.new("Invalid rating #{@rating}") if !(1..5).include? (@rating) unless rating == nil
        
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
      if end_time != nil
        trip_duration = @end_time - @start_time
        return trip_duration
      else
        return "This trip is still in progress."
      end
    end

    private

    def self.from_csv(record)
      return self.new(
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
