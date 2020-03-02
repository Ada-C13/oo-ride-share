require 'csv'
require 'time'
require 'pry'
require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver, :driver_id

    def initialize(
          id:,
          driver: nil,
          driver_id: nil,
          passenger: nil,
          passenger_id: nil,
          start_time:,
          end_time:,
          cost: 0,
          rating:
        )
      super(id)

      if passenger
        set_passenger(passenger)
      elsif passenger_id
        @passenger_id = passenger_id
      else
        raise ArgumentError.new("Passenger or passenger_id is required to initialize a trip.")
      end

      if driver
        set_driver(driver)
      elsif driver_id
        @driver_id = driver_id
      else
        raise ArgumentError.new("Driver or driver_id is required to initialize a trip.")
      end

      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating

      if end_time && start_time > end_time 
        raise ArgumentError.new("Start time #{start_time} is after #{end_time}. Please try again with valid time fields.")
      end

      if @rating && (@rating > 5 || @rating < 1)
        raise ArgumentError.new("Invalid rating #{@rating}. Please try again with a valid rating between 1-5.")
      end
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
        "ID=#{id.inspect} " +
        "PassengerID=#{passenger&.id.inspect}>"
    end

    def connect(passenger, driver)
      set_passenger(passenger)
      set_driver(driver)
      passenger.add_trip(self)
      driver.add_trip(self)
    end

    def duration 
      @end_time - @start_time 
    end

    def set_passenger(passenger)
      @passenger = passenger
      @passenger_id = passenger.id
    end

    def set_driver(driver)
      @driver = driver
      @driver_id = driver.id
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
              rating: record[:rating]
            )
    end
  end
end