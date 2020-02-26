require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord

    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      @vin = vin

      if @vin.to_s.length != 17
        raise ArgumentError.new("Wrong length of vin!")
      end

      @status = status

      if ![:AVAILABLE, :UNAVAILABLE].include?@status.upcase.to_sym
        raise ArgumentError.new("Invalid status.")
      end
      
      @trips = [] || trips
    end

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status]
      )
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      # sum_of_ratings = 0

      # @trips.length.each do |trip|
      #   sum_of_ratings += trip.rating
      # end

      # return (sum_of_ratings / @trips.length)
    end

  end
end
