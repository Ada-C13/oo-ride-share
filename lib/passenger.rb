require_relative 'csv_record'
require 'awesome_print'

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
      #self.trip << trip
    end

    def net_expenditure
      total_spent = 0
      trips.each do |trip| 
        total_spent += trip.cost
      end
      return total_spent
    end

    def total_time_spent
      total_time = 0
      @trips.each do |trip|
        if trip.end_time != nil
          total_time += trip.duration
        end
      end
      return total_time
    end

    private

    def self.from_csv(record)
      #came as: return Passenger.new
      #same as: return self.new
      return new(
        id: record[:id],
        name: record[:name],
        phone_number: record[:phone_num]
      )
    end
  end
end

# passengers =RideShare::Passenger.load_all(full_path: '../support/passengers.csv')
# ap passengers 