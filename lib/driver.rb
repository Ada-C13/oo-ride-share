require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)

      super(id)
      @name = name
      @vin = vin
      raise ArgumentError.new("Incorrect VIN length.") if vin.length != 17

      @status = status
      raise ArgumentError.new("Invalid status.") unless [:AVAILABLE, :UNAVAILABLE].include? status

      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      return 0 if trips.length == 0
      rating_sum = trips.reduce(0) { |sum, trip| sum + trip.rating }
      average_rating = rating_sum / trips.length
      return average_rating.to_f
    end

    # NOTE: The following addresses the question of "What if the cost of a trip was less than $1.65?"
    # The executive decision was made that if a trip cost less than $3 the company was generous and gave
    # them the entire profit, otherwise the company charges the fees as per usual.
    def total_revenue
      total = 0
      trips.each do |trip|
        if trip.cost > 3
          total += ((trip.cost.to_f - 1.65) * 0.8)
        else
          total += trip.cost.to_f 
        end
      end
      return total
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
