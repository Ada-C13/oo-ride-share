require 'csv'
require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips
    def initialize(
      id:,
      name:,
      vin:,
      status: :AVAILABLE,
      trips: nil
      )
      super(id)
      (vin.length == 17) ? (@vin = vin) : (raise ArgumentError)
      [:AVAILABLE, :UNAVAILABLE].include?(status) ? (@status = status.to_sym) : (raise ArgumentError)

      @name = name
      @trips = trips || []

    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      return 0 if trips.length == 0
      trip_ratings = trips.map do |trip|
        trip.rating.to_f
      end

      return trip_ratings.sum / trip_ratings.length
    end

    def total_revenue
      trip_revenues = trips.map do |trip|
        if trip.cost > 1.65
          (trip.cost - 1.65) * 0.8
        else
          0
        end
      end
      return trip_revenues.sum.round(2)
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