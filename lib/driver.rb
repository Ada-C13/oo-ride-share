require 'csv'
require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord

    attr_reader :name, :vin
    attr_accessor :status, :trips
    
    def initialize(
                  id:,
                  name:,
                  vin:,
                  status: :AVAILABLE,
                  trips: nil
        )
      super(id)

      @name = name
      @vin = vin

      unless vin.length == 17
        raise ArgumentError
      end

      @status = status

      unless (status == :AVAILABLE || status == :UNAVAILABLE)
        raise ArgumentError
      end

      @trips = trips || []

      unless super(id) > 0 
        raise ArgumentError
      end
    end

    # def inspect
    #   # Prevent infinite loop when puts-ing a Trip
    #   # trip contains a passenger contains a trip contains a passenger...
    #   "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
    #     "ID=#{id.inspect} " +
    #     "PassengerID=#{passenger&.id.inspect}>"
    # end

    # DO WE need this still?

    # def connect(passenger)
    #   @passenger = passenger
    #   passenger.add_trip(self)
    # end

    def add_trip(trip)
      @trips << trip
    end
    
    def average_rating
      sum_rating = 0.0
      if @trips.length == 0
        return 0
      else
        @trips.each do |trip|
          sum_rating += trip.rating 
        end
      end
      return sum_rating / @trips.length
    end

    def total_revenue
      revenue = 0.0
      # Return 0 if no trips driven
      if @trips.length == 0
        return 0
      else
        @trips.each do |trip|
          revenue += trip.cost
        end
      end
      # Return 0 if revenue <= 1.65 (flat cost) per trip, otherwise run revenue formula
      if revenue > (1.65 * @trips.length)
        total_revenue = (revenue - (1.65 * @trips.length))* 0.8
        return total_revenue
      else 
        return 0
      end
    end

    def add_requested_trip(trip)
      @trips << trip
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
