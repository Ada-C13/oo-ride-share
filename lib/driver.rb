require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      @vin = vin
      @status = status.to_sym
      @trips = trips || []

      if @vin.length != 17
        raise ArgumentError, "vin: #{vin} is not valid"
      end 
      
      if (@status == :AVAILABLE || @status == :UNAVAILABLE) == false 
        raise ArgumentError, "status:#{status} is not a valid status"
      end
    end

    def add_trip(trip)
      @trips << trip
    end 

    def average_rating
      if trips.length == 0
        return 0
      end

      total_rating = 0.0

      trips.each do |trip|
        total_rating += trip.rating
      end
      return total_rating / trips.length
    end

    def total_revenue
      if trips.length == 0
        return 0
      end

      total = 0.0

      trips.each do |trip|
        if trip.cost > 1.65
          total += (trip.cost - 1.65)
        else
          total += trip.cost
        end
      end
      return (total * 0.8).round(2)
    end

    private

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