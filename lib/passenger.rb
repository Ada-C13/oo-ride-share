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

    # Return Total Amount of Money Passenger Spent on Trips
    def net_expenditures
      # total_cost = 0
      # @trips.each do |trip|
      #   total_cost += trip.cost
      # end
      # return total_cost
      return @trips.map { |trip| trip.cost}.sum # returns an array w/ trip costs and sums
    end

    # Return Total Amount of Time Passenger Spent on Trips
    def total_time_spent
      return @trips.map { |trip| trip.duration}.sum
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
