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
    
    def add_trip(trip)
      @trips << trip 
    end
    
    def average_rating
      average = 0  
      if @trips.length == 0
        return 0
      else 
        rating_arr = @trips.map do |trip|
          trip.rating
        end 
        average = rating_arr.sum / rating_arr.length 
        return average.to_f.round(2) 
      end   
    end 
    
    #This method calculates that driver's total revenue across all their trips. Each driver gets 80% of the trip cost after a fee of $1.65 per trip is subtracted.
    def total_revenue 
      fee = 1.65
      percentage = 0.80 
      if @trips.length == 0
        return 0
      else 
        cost_arr = @trips.map do |trip|
          if trip.cost < fee 
            trip.cost * percentage
          else
            (trip.cost - fee) * percentage
          end
        end 
      end 
        revenue = cost_arr.sum 
      return revenue 
    end 
    
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
