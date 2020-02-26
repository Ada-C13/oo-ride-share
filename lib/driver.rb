require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name

      if (vin.is_a? String)  && vin.length == 17
        @vin= vin
      else
        raise ArgumentError.new("Vin must be 17 characters long")
      end

      if status == :AVAILABLE || status == :UNAVAILABLE
        @status = status
      else
        raise ArgumentError.new("Status must be AVAILABLE or UNAVAILABLE")
      end
    
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      all_ratings = @trips.map{|trip|trip.rating.to_f}
      return 0 if all_ratings.length == 0
      average_rating = all_ratings.sum / all_ratings.length
      return average_rating
    end

    def total_revenue
      all_costs = @trips.map{|trip|trip.cost}
      return 0 if all_costs.length == 0
      total_revenue = (all_costs.sum - 1.65) * 0.8
      return total_revenue.round(2)
    end

    def make_driver_unavailable
      return @status = :UNAVAILABLE
    end

    private

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym
      )
    end
  end
end
