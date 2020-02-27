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
      if @trips == nil || @trips.length == 0
        return "No trips taken"
      else 
        total = 0 
        @trips.each do |trip|
          total += trip.cost
        end 
      end 
        return total
    end

    def total_time_spent 
      if @trips == nil || @trips.length == 0
        return "No trips taken"
      else 
        total = 0 
        @trips.each do |trip|
          total += trip.calculate_seconds
        end 
      end 
        return total
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
