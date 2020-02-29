require 'csv'
require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips 
    VALID_STATUSES = [:AVAILABLE, :UNAVAILABLE]
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips:[])
      super(id)
      @name = name
      raise(ArgumentError, "This VIN exceeds more than 17 characters") unless vin.length <= 17 && vin.length >=1 
      @vin = vin
      raise(ArgumentError, "Not a valid status") unless status == :AVAILABLE || status == :UNAVAILABLE
      @status = status
      @trips = trips
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    def average_rating
      trip_ratings = 0 
      trips.each do |trip|
        trip_ratings += trip.rating 
      end
      
      if trip_ratings > 0
        return (trip_ratings / trips.length).to_f.round(2) 
      else 
        return 0
      end
    end
    
    def total_revenue 
      # handle case if there's no trips 
      if trips.length == 0 
        return 0.0
      end 
      
      # calculate total revenue
      total_rev = 0.0 
      trips.each do |trip|
        total_rev += trip.cost
      end
      
      # handle case if total revenue is less than 1.65 (i.e. make sure there's no negative values)
      if total_rev < 1.65
        return 0.0 
      else 
        return ((total_rev - 1.65)*0.8).to_f.round(2) # subtract fee and make sure driver gets their 80% cut
      end
    end
    
    def switch_status
      if @status == :AVAILABLE
        @status = :UNAVAILABLE
      elsif @status == :UNAVAILABLE
        @status = :AVAILABLE
      end  
    end 
    
    private 
    
    def self.from_csv(record)
      return new(
      id: record[:id],
      name: record[:name],
      vin: record[:vin],
      status: record[:status].to_sym
      )
    end
  end
end
