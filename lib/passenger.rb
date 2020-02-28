require_relative 'csv_record'
require_relative 'trip'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number
    attr_accessor :trips

    def initialize(id:, name:, phone_number:, trips: nil)
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def net_expenditures
      passenger_total = 0
      self.trips.each do |trip|
        passenger_total += trip.cost
      end
      return passenger_total
    end

    def total_time_spent
      passenger_time = 0
      self.trips.each do |trip|
        if trip.end_time != nil
          passenger_time += trip.trip_duration
        end
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