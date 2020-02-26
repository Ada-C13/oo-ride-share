require_relative 'csv_record'
require_relative 'trip_dispatcher'

module RideShare
  class Driver < CsvRecord
		attr_reader :id, :name, :vin, :trips
		attr_accessor :status

    def initialize(id:, name:, vin: , status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
			@vin = vin.strip
			@status = status
			@trips = trips || []
			
			raise ArgumentError, "Invalid vin" if @vin.length != 17
    end

		def add_trip(trip)
      @trips << trip
		end
		
		def average_rating 
			return 0 if @trips == []
			@trips.map {|trip| trip.rating.to_f}.inject(:+) / @trips.length
		end

		def total_revenue
			return 0 if @trips == [] 
			
			@trips.map do |trip| 
				trip.cost < 1.65 ? 0 : (trip.cost - 1.65) * 0.80
			end.inject(:+)
		end

		def change_status
			@status == :AVAILABLE ? @status = :UNAVAILABLE : @status = :AVAILABLE
		end

    private

    def self.from_csv(record)
      return new(
        id: record[:id].to_i,
				name: record[:name],
				vin: record[:vin],
				status: record[:status].strip.to_sym
      )
    end
  end
end