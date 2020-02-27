require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips
    attr_writer :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

			raise ArgumentError.new("Driver status is not valid") unless %i[AVAILABLE UNAVAILABLE].include?(status)
      raise ArgumentError.new("VIN must be at least 17 characters") unless vin.length == 17
      raise ArgumentError.new("Invalid driver ID") unless id > 0

      @name = name
			@vin = vin
			@status = status
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def assign_driver(trip)
      @status = :UNAVAILABLE
      add_trip(trip)
    end

    def average_rating
			ratings = []
			@trips.each do |trip|
				ratings << trip.rating unless trip.rating == nil
			end
      return @trips.length == 0 ? 0 : (ratings.sum / ratings.length).to_f.round(1)
    end

    def total_revenue
      if @trips.length == 0
        return 0
      else
        revenue = []
        @trips.each do |trip| 
          revenue << ((trip.cost - 1.65)* 0.8) unless trip.cost == nil
        end
        return revenue.sum.round(2)
      end
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
