require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

			raise ArgumentError.new("Driver status is not valid") unless %i[AVAILABLE UNAVAILABLE].include?(status)
      raise ArgumentError.new("VIN must be at least 17 characters") unless vin.length == 17
      raise ArgumentError.new("Invalid driver ID") unless id > 0

      @name = name
			@vin = vin
			@status = status || :UNAVAILABLE
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      ratings = @trips.map {|trip| trip.rating}
      return @trips.length == 0 ? 0 : (ratings.sum / @trips.length).to_f.round(1)
    end

    def total_revenue
      if @trips.length == 0
        return 0
      else
        revenue = @trips.map {|trip| ((trip.cost - 1.65)* 0.8)}
        return revenue.sum.round(2)
      end
    end
    
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
