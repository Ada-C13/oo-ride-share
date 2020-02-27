require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

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

    # def add_trip(trip)
    #   @trips << trip
    # end

    # def average_rating
    #   total_ratings = 0
    #   if trips.length == 0
    #     return 0
    #   end
    #   trips.each do |trip|
    #     if trip.rating != nil
    #       total_ratings += trip.rating
    #     end
    #   end
    #   return (total_ratings / trips.length.to_f).round(2)
    # end

    # def total_revenue
    # end

    private

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status],
             )
    end
  end
end
