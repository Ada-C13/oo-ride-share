require 'csv'
require 'awesome_print'

require_relative 'csv_record'
require 'pry'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      @vin = vin
      @status = status
      @trips = trips || []

      unless @vin.length == 17 && (@vin.is_a? String)
        raise ArgumentError.new ('Your VIN is wrong.')
      end

      approved_status = [:AVAILABLE, :UNAVAILABLE]

      unless approved_status.include?(@status)
        raise ArgumentError.new ('You must provide one of the following statuses :available, :unavailable')
      end

    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      return @trips.map {|trip| trip.rating}.sum.to_f / (@trips.size == 0 ? 1 : @trips.size)
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


