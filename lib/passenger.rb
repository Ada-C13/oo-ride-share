require_relative 'csv_record'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips

    def initialize(id:, name:, phone_number:, trips: nil, cost: 0)
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips || []
      @cost = cost 
    end

    def add_trip(trip)
      @trips << trip
      @cost += trip.cost 
    end

    def net_expenditures
      total = 0
      pass_money_spent = trips.each do |trip|
        total += trip.cost
      end
      return total
    end

    def total_time_spent
      total_amount_time = 0
      @trips.each do |trip|
        total_amount_time += trip.duration
      end
      return total_amount_time
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