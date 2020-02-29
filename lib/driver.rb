require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin: nil, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      if vin.length != 17
        raise ArgumentError, "vin must be 17 characters long"
      end
      @vin = vin
      @status = status
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      rating_total = 0
      if @trips.empty?
        return 0
      else
        @trips.each do |trip|
          rating_total += trip.rating
        end
        return rating_total / @trips.length.to_f.round(2)
      end
    end

    def total_revenue
      total_revenue = 0
      if @trips.empty?
        return 0
      else
        @trips.each do |trip|
          if trip.cost >= 1.65
            total_revenue += trip.cost * 0.8 - 1.65
          else
            total_revenue
          end
        end
      end
      return total_revenue
    end

    private

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status].to_sym,
             )
    end
  end
end
