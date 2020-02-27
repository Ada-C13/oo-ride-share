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
      valid_array = @trips.reject {|trip|trip.cost == nil}
      cost_array = valid_array.map {|trip|trip.cost}
      total_cost = cost_array.sum
      return total_cost
    end

    def total_time_spent
      valid_array = @trips.reject {|trip|trip.end_time == nil}
      time_array = valid_array.map{|trip|trip.duration}
      total_time = time_array.sum.to_i
      puts "The total time spent on trips is #{(total_time / 60).to_i} minutes" 
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
