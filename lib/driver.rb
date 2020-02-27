require_relative 'csv_record'


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
      average = 0 #i need an array to calcute the average  
      if @trips != nil 
        rating_arr = @trips.map do |trip|
          trip.rating
        end 
        average = rating_arr.sum / rating_arr.length 
      end 
      return average.to_f.round(2) 
    end 

    #This method calculates that driver's total revenue across all their trips. Each driver gets 80% of the trip cost after a fee of $1.65 per trip is subtracted.
    def total_revenue 
      revenue = 0 
      if @trips != nil 
        cost_arr = @trips.map do |trip|
          trip.cost 
        end 
        fee = 1.65 * cost_arr.length
        percentage = 0.80 
        total_trips = cost_arr.sum 
        revenue = (total_trips - fee) * percentage
      end 
      return revenue 
    end 

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
