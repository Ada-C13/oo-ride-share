require 'csv'
require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status
    
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
      number_of_finished_trips = 0
      @trips.each do |trip|
        if trip.end_time != nil
          total_rating += trip.rating
          number_of_finished_trips += 1
        end
      end

      if @trips.length > 0 
        average_rating = (total_rating / number_of_finished_trips).to_f
      else
        average_rating = 0
      end
    end

    def total_revenue
      total_revenue = 0
        @trips.each do |trip|
          if trip.end_time != nil
          total_revenue += (trip.cost.to_f-1.65) * 0.80
          end
        end
      return total_revenue
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
