require_relative 'csv_record'

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

    def net_expenditures
      total = 0
      pass_money_spent = trips.each do |trip|
        if !trip.cost 
          next
        end
        total += trip.cost
      end
      return total 
    end

    def total_time_spent
      time = 0
      total_amount_time = trips.each do |trip|
        if !trip.duration
          next
        end
        time += trip.duration
      end
      time
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