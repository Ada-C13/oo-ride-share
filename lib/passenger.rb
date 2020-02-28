require_relative "csv_record"

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
      if @trips.length == 0 || @trips == nil
        raise ArgumentError.new("This passenger has no trips")
      else
        total_cost = 0
        @trips.each do |trip|
          total_cost += trip.cost
        end
      end
      return total_cost
    end

    def total_time_spent
      if @trips.length == 0 || @trips == nil
        raise ArgumentError.new("This passenger has no trips")
      else
        total_time = 0
        @trips.each do |trip|
          total_time += trip.duration
        end
      end
      return total_time
    end

    private

    def self.from_csv(record) #Passenger.new, new, @new, self.new
      return new(
               id: record[:id],
               name: record[:name],
               phone_number: record[:phone_num],
             )
    end
  end
end
