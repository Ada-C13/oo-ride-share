require 'csv'
require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :trips
    attr_accessor :status

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
      completed_trips = trips.select{ |trip| trip.rating != nil }

      trip_ratings = completed_trips.map { |trip| trip.rating.to_f }

      return 0 if trip_ratings.length == 0
      return trip_ratings.sum / trip_ratings.length
    end

    def total_revenue
      completed_trips = trips.select{ |trip| trip.cost != nil && trip.cost > 1.65 }
      trip_revenues = completed_trips.map { |trip| (trip.cost - 1.65) * 0.8 }
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