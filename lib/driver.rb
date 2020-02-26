# Wave 2
require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name 
      #Not sure if || is the best choice trips is optional
      @status = status
      raise ArgumentError, "Invalid status" unless [:AVAILABLE, :UNAVAILABLE].include?(@status)
      @trips = trips || []
      @vin = vin
      raise ArgumentError, "Invalid VIN" if @vin.length != 17
      # if vin.length == 17 
      #   @vin = vin 
      # else 
      #   raise ArgumentError, 'Vin is of wrong length'
      # end 
    end

    # Maybe we can use constants or change top
    def make_driver_unavailable
      @status = :UNAVAILABLE
    end 

    def add_trip(new_trip) 
      if new_trip.driver_id == @id 
        @trips << new_trip 
      end 
    end 

    def average_rating 
      if @trips.length > 0
        ratings = @trips.map do |trip|
          trip.rating
        end
        #compact! () is a Hash class method which returns the Hash after removing all the ‘nil’ value elements (if any) from the Hash. If there are no nil values in the Hash it returns back the nil value.
        ratings.compact!
        (ratings.sum / ratings.length).to_f
      elsif @trips.length == 0
        raise ArgumentError, 'Driver without ratings'
      end
    end

    # don't love the nil in else  or compact! look later
    def total_revenue 
      if @trips.length > 0 
        revenue = @trips.map do |trip|
          if trip.cost != nil
            (trip.cost - 1.65) * 0.8 
          else
            nil
          end
        end 
        revenue.compact!
        revenue.sum
      elsif @trips.length == 0 
        raise ArgumentError, 'Driver has no trips'
      end 
    end

    # Implement the from_csv template method
    private
    def self.from_csv(record)
      # Do I need self here?
      return self.new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym
      )
    end
  end
end