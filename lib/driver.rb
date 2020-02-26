require 'csv'
require 'awesome_print'

require_relative 'csv_record'
require 'pry'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status:, trips: nil)
      super(id)
      

      @name = name
      @vin = vin
      @status = status
      @trips = trips || []

      approved_status = [:AVAILABLE, :UNAVAILABLE]

      unless @vin.length != 17 || @vin.is_a?String
        raise ArgumentError.new ('Your VIN is wrong.')
      end

      unless approved_status.include?(@status)
        raise ArgumentError.new ('You must provide one of the following statuses :available, :unavailable')
      end

    


    end

    def add_trip(trip)
      @trips << trip
    end

    private   

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status]
      )
    end

  end

# drivers = RideShare::Driver.load_all(full_path: '../support/drivers.csv')
# ap drivers
end


