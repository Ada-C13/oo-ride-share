require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin:, status:, trips: nil)
      super(id)
      @name = name
      if vin.length != 17
        raise ArgumentError, "Vin length is invalid"
      end
      @vin = vin

      if [:AVAILABLE, :UNAVAILABLE].include?(status.to_sym)
        @status = status.to_sym
      else
        raise ArgumentError, "Invalid status"
      end

       @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      if @trips.length == 0
        return "No trips taken"
      else
        count = 0
        sum = 0 
        @trips.each do |trip| 
          sum += trip.rating 
          count += 1
        end 
      end 
        return (sum/count)
    end 


    def total_revenue 
      if @trips.length == 0
        return "No revenue"
      else
        total = 0.0
        @trips.each do |trip|
          if trip.cost < 1.65
            total += (trip.cost * 1.8)
          else
            total += (trip.cost - 1.65) * 1.8
          end 
        end 
      end 
      return total 
    end 






    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status]
      )
    end 

  end
end