require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      if vin.length != 17
        raise ArgumentError.new("VIN length has to be 17")
      end

      driver_status = [:AVAILABLE, :UNAVAILABLE]
      if !driver_status.include?(status)
        raise ArgumentError.new("Driver status invalid.")
      end 

      @name = name
      @vin = vin
      @status = status
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def ongoing_trips
      ongoing_trip = []
      self.trips.each do |trip|
        if trip.end_time == nil
          ongoing_trip << trip
        end
      end

      return ongoing_trip
    end

    def average_rating
      rating = 0
      trips.each do |trip|
        if trip.rating == nil
          rating += 0
        else 
          rating += trip.rating
        end
      end

      if trips.length == 0
        return 0 
      end

      return rating.to_f/trips.length
    end

    def total_earnings
      earnings = 0.0

      trips.each do |trip|
        if trip.cost == nil
          earnings += 0
        else
          earnings += cost
        end
      end
      
      return earnings
    end

    def status_to_unavailable
      self.status = :UNAVAILABLE
    end

    def get_new_trip(trip)
      self.add_trip(trip)
      self.status_to_unavailable
    end

    private

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status].to_sym,
               trips: record[:trips]
             )
    end
  end
end