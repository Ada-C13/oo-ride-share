require 'csv'
require_relative 'csv_record'
require 'time'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)


      super(id)
      @name = name
      @vin = vin #17 char
      @status = status
      @trips = trips || []
      
  
      if status.class == String
        @status = status.to_sym
      end

      if vin.class == Integer
        vin.to_s
      end

      valid_statuses = [:AVAILABLE, :UNAVAILABLE]
      raise ArgumentError if !valid_statuses.include?(@status)

      raise ArgumentError if id <= 0 || id.nil?

      raise ArgumentError if vin.length != 17

      # case status
      # when :AVAILABLE, :UNAVAILABLE
      #   @status = status
      # else 
      #   raise ArgumentError
      # end

    end #end of initialize

    def add_trip(trip)
      trips << trip
    end

    
    def average_rating
      total_ratings = 0
      @trips.each do |trip|
        total_ratings += trip.rating
      end

      if total_ratings == 0
        return 0
      else
        return average_rating = total_ratings.to_f / @trips.length
      end
    end

    def total_revenue
      total_revenue = 0
      if @trips == nil
        return 0
      end 

      @trips.each do |trip|
        if trip.cost <= 1.65
          total_revenue += 0
        else
          trip_pay = trip.cost - 1.65
          trip_pay = trip_pay * 0.80
          total_revenue += trip_pay
        end
      end
      return total_revenue
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