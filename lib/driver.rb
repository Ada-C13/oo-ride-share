require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord

    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      @vin = vin

      if @vin.to_s.length != 17
        raise ArgumentError.new("Wrong length of vin!")
      end

      @status = status.to_sym

      if ![:AVAILABLE, :UNAVAILABLE].include?@status.upcase.to_sym
        raise ArgumentError.new("Invalid status.")
      end
      
      @trips = [] || trips
    end

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status]
      )
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      sum_of_ratings = 0.0

      return 0 if @trips.length == 0

      @trips.each do |trip|
        sum_of_ratings += trip.rating
      end

      return (sum_of_ratings / @trips.length)
    end

    def total_revenue
      return 0.0 if @trips.length == 0

      sum_of_trip_costs = 0.0

      @trips.each do |trip|
        if trip.cost < 1.65
          net_trip = trip.cost
        else
          net_trip = trip.cost - 1.65
        end

        sum_of_trip_costs += net_trip
      end

      return (sum_of_trip_costs * 0.80)
    end

    def update_status(trip)
      add_trip(trip)
      @status = :UNAVAILABLE
    end

  end
end
