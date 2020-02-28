require_relative 'csv_record'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips

    def initialize(id:, name:, phone_number:, trips: [])
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def net_expenditures
      total_cost = 0
      total_cost = @trips.sum { 
        |trip| unless trip.cost == nil
        trip.cost 
      end
    }
      return total_cost
    end

    def total_time_spent
      total_time = @trips.sum { 
        |trip| unless trip.end_time == nil
          trip.duration
        end
      }
      return total_time
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
