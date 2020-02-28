require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin:, trips: nil, status: :AVAILABLE)
      super(id)
      @name = name
      @vin = vin
      @trips = trips || []
      @status = status
      status_options = [:AVAILABLE, :UNAVAILABLE]

      raise ArgumentError if @vin.length != 17 || @vin.class != String
      raise ArgumentError if !status_options.include?(status)
      raise ArgumentError if @id <= 0 || @id.class != Integer
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      return 0 if @trips.length == 0
      complete_trips = @trips.reject { |trip| trip.rating == nil }
      rated_trips = complete_trips.map { |trip| trip.rating }
      average = rated_trips.sum / rated_trips.length
      return average.to_f.round(2)
    end

    def total_revenue
      fee = 1.65
      percentage = 0.80
      return 0 if @trips.length == 0
      complete_trips = @trips.reject { |trip| trip.cost == nil }
      cost_arr = complete_trips.map do |trip|
        if trip.cost < fee
          trip.cost * percentage
        else
          (trip.cost - fee) * percentage
        end
      end
      revenue = cost_arr.sum
      return revenue
    end

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
