require 'csv'
require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips
    
    def initialize(id: , name: , vin: , status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      @vin = vin
      @status = status
      @trips = trips || []
      
      if vin.length !=17
        raise ArgumentError, "Vin number must be string of length 17"
      end
      
      if !([:AVAILABLE, :UNAVAILABLE].any? { |x| x == status })
        raise ArgumentError, "Status is #{status}; needs to be :AVAILABLE or :UNAVAILABLE"
      end
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      total_rating = 0
      @trips.each do |trip|
        total_rating += trip.rating
      end

      if @trips.length > 0 
        average_rating = (total_rating / @trips.length).to_f
      else
        average_rating = 0
      end
    end

    def total_revenue
      total_revenue = 0
        @trips.each do |trip|
          total_revenue += (trip.cost.to_f-1.65) * 0.80
        end
      return total_revenue
    end

    def flip_status
      if status == :UNAVAILABLE
        status = :AVAILABLE
      else 
        status = :UNAVAILABLE
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
