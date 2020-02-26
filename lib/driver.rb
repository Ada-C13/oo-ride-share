# Wave 2
require_relative 'csv_record'
# Driver inherits from CsvRecord
module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status
    
    # Inititalize driver
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)
      @name = name 
      @status = status
      raise ArgumentError, "Invalid status" unless [:AVAILABLE, :UNAVAILABLE].include?(@status)
      @trips = trips
      @vin = vin
      raise ArgumentError, "Invalid VIN" if @vin.length != 17
    end

    # Add new trip to trips
    def add_trip(new_trip) 
      @trips << new_trip  
    end 

    # Calculate driver's average rating from trips
    def average_rating 
      if trips.length == 0
        return 0
      end
      ratings = trips.map do |trip|
        trip.rating
      end
      return ratings.sum.to_f / ratings.length
    end

    # Calculate driver's total revenue minus trip fee
    def total_revenue
      if trips.length == 0
        return 0
      end
      revenue = trips.map do |trip|
        if trip.cost >= 1.65
          (trip.cost - 1.65) * 0.8 
        else
          0
        end
      end 
      return revenue.sum
    end

    # Implement the from_csv template method
    private
    def self.from_csv(record)
      return self.new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym
      )
    end
  end
end