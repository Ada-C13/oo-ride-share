require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
		attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin: , status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
			@vin = vin.strip
			@status = status
			@trips = trips || []
			
			if @vin.length != 17
				raise ArgumentError, "Invalid vin"
			end
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

			@trips.map {|trip| 
				trip.cost < 1.65 ? 0 : (trip.cost - 1.65) * 0.80
			}.inject(:+)
		
		end

		# def self.first_available_driver
		# 	count = 0 
		# 	while self.
		# 	if self.firs
		# 	self.first 
		# end

    private

    def self.from_csv(record)
      return new(
        id: record[:id].to_i,
				name: record[:name],
				vin: record[:vin],
				status: record[:status].to_sym
      )
    end
  end
end