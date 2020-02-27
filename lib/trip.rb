require 'csv'
require 'time'
require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    # Took out the :id below because redundant (inherited from CsvRecord's attr_reader).
    attr_reader :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver, :driver_id

    def initialize(
          id:,
          driver_id: nil,
          driver: nil,
          passenger: nil,
          passenger_id: nil,
          start_time:,
          end_time:,
          cost: nil,
          rating:
        
        )
      super(id)

      unless passenger_id == nil
        if passenger_id < 1
        raise ArgumentError
        end
      end

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

      @start_time = start_time
      @end_time = end_time

      unless @end_time == nil 
        if @start_time > @end_time
        raise ArgumentError, 'Trip start time cannot be after end time'
        end
      end

      @cost = cost
      @rating = rating

      unless @rating == nil
        if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
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
      passenger.add_trip(self)
      # update connect method to connect the driver as well as passenger (added in as a param too)
      @driver = driver
      driver.add_trip(self)
    end

    def trip_duration
      unless end_time == nil
      duration = end_time.to_i - start_time.to_i
      end
    return duration

    end

    private

   

    def self.from_csv(record)
      return new(
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
