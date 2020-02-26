require_relative 'csv_record'

module RideShare 
  class Driver < CsvRecord 
    attr_reader :id, :name, :vin, :trips 
    attr_accessor :status
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil) 
      super(id)

      if ![:AVAILABLE, :UNAVAILABLE].include?(status)
        raise ArgumentError.new("#{status} is an invalid status.")
      end 

      if vin.length != 17 
        raise ArgumentError.new("VIN has the wrong length.")
      end 

      @name = name
      @vin = vin 
      @status = status
      @trips = trips || [] 
    end 

    def add_trip(trip)
      @trips << trip
    end
    
    def average_rating
      total_rating = 0.0
      if @trips.empty?
        return 0
      else
        @trips.each do |trip|
          total_rating += trip.rating
       end
       return (total_rating / @trips.length).round(2)
      end
    end

    def total_revenue
      total_revenue = 0
      if @trips.empty?
        return 0
      else
        @trips.each do |trip|
          total_revenue += ((trip.cost - 1.65) * 0.80)
        end
        return total_revenue.round(2)
      end
    end

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
