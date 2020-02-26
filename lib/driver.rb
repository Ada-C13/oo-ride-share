require_relative 'csv_record'
require 'csv'
require 'time'
require 'awesome_print'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips
    
    def initialize(
      id:,
      name:,
      vin:,
      status:,
      trips: nil
      )
      super(id)

      @name = name 
      @vin = vin
      @status = status
      @trips = trips || []
    
      #Raise argument for vin
      if @vin.length != 17
        raise ArgumentError.new("Invalid VIN number.")
      end

      #Raise argument for status
      if [:AVAILABLE, :UNAVAILABLE].include?(@status)
        raise ArgumentError.new("Invalid status.")
      end
    end
    
    #Adding trips to the driver
    def add_trip(trip)
      @trips << trip
      #self.trip << trip
    end

    private 

    def self.from_csv(record)  
      return Driver.new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status]
      )
      end
    end


    drivers =RideShare::Driver.load_all(full_path: '../support/drivers.csv')
    ap drivers

















  end

drivers =RideShare::Driver.load_all(full_path: '../support/drivers.csv')
ap drivers