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

    def net_expenditures # will return the total amount of money spent on trips
      total_cost = 0
      @trips.each do |trip| # iterate through the @trips to get through all the trips
        if trip.end_time != nil
          total_cost += trip.cost 
        end
      end
      return total_cost
   end

   def total_time_spent
    total_amount_time = 0
    @trips.each do|trip|
      if trip.end_time != nil
        total_amount_time += trip.duration_in_seconds
      end
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
