require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

			raise ArgumentError.new("Driver status is not valid") unless %i[AVAILABLE UNAVAILABLE].include?(status)
			raise ArgumentError.new("VIN must be at least 17 characters") unless vin.length == 17

      @name = name
			@vin = vin
			@status = status || :UNAVAILABLE
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

#     def net_expenditures
#       costs = @trips.map {|trip| trip.cost}
#       return costs.sum
#     end

#     def total_time_spent
#       # calculating total amount of time in seconds.
#       durations = @trips.map {|trip| trip.duration}
#       return durations.sum
#     end

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
