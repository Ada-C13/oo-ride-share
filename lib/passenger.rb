require_relative 'csv_record'
# Passenger inherits from CsvRecord
module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips
    # Initialize new passenger
    def initialize(id:, name:, phone_number:, trips: nil)
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    # Culculate how much passenger has spent on trips
    def net_expenditures
      if trips == nil || trips.length == 0
        return 0
      end
      total_cost = trips.sum {|trip| 
        if trip.cost == nil
          0
        else
          trip.cost
        end
      }
      return total_cost
    end

    # Calculate passenger's total time spent on trips
    def total_time_spent
      total_duration = trips.sum {|trip| trip.duration}
      return total_duration
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
