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
      cost_array = @trips.map {|trip|trip.cost}
      total_cost = cost_array.sum
      return total_cost
    end

    def total_time_spent
      time_array = @trips.map{|trip|trip.duration}
      total_time = (time_array.sum / 60).to_i
      puts "The total time spent on trips is #{total_time} minutes" 
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
