require_relative 'csv_record'
require_relative 'trip'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips

    def initialize(id:, name:, phone_number:, trips: nil)
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    # Add an instance method, net_expenditures, to Passenger that will return the total amount of money that passenger has spent on their trips

    def net_expenditures
      passenger_total = 0
      self.trips.each do |trip|
        passenger_total += trip.cost
      end
      return passenger_total
    end

    # Add an instance method, total_time_spent to Passenger that will return the total amount 
    # of time that passenger has spent on their trips

    def total_time_spent
      passenger_time = 0
      self.trips.each do |trip|
        passenger_time += trip.trip_duration
      end
      return passenger_time
    end


    private

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        phone_number: record[:phone_num]
      )
    end
    
  end
end
