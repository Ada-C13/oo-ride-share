require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      
      @name = name
      @vin = vin
      if @vin.length != 17
        raise ArgumentError, "vin length must be 17 characters"
      end
      
      @status = status
      valid_status = [:AVAILABLE, :UNAVAILABLE]
      if !(valid_status.include? status)
        raise ArgumentError, "invalid status"
      end
      
      @trips = trips || []
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    def average_rating 
      if @trips.empty?
        return 0
      end
    
      @trips.delete_if { |trip| trip.rating == nil }

      all_trips = @trips.map { |trip| trip.rating }.sum
      trip_count = @trips.length
      
      average_rating = all_trips.to_f / trip_count
      
      return average_rating
    end
    

    def total_revenue
      nil_check = @trips.delete_if { |trip| trip.cost == nil }

      gross_revenue = nil_check.map { |trip| trip.cost }
    
      net_revenue = []
      gross_revenue.each do |cost|
        if cost > 1.65
          cost = (cost - 1.65) * 0.8
          net_revenue << cost
        else cost *= 0.8
          net_revenue << cost
        end
      end
      
      return net_revenue.sum
    end
    

    def modify_status
      # when a driver is assigned a new trip, driver status is now :UNAVAILABLE
      return self.status = :UNAVAILABLE
    end
    
    private
    
    def self.from_csv(record)
      return Driver.new( 
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym
      )
    end
  end 
end 

