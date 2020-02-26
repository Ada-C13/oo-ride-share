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
      @status = status.to_sym #need to convert this to symbol
      @trips = trips || []
    
      #Raise argument for vin
      if @vin.length != 17
        raise ArgumentError.new("Invalid VIN number, needs to be 17 in length.")
      end

      #Raise argument for status
      if ![:AVAILABLE, :UNAVAILABLE].include?(@status) #status is symbol here
        puts @id
        puts @name
        raise ArgumentError.new("Invalid status.")
      end
    end
    
    #Wave 2: Adding trips to the driver
    def add_trip(trip)
      @trips << trip
      #self.trip << trip
    end

    #Wave 2: Driver's Average Rating
    def average_rating
      total_ratings = 0
      @trips.each do |trip|
        total_ratings += trip.rating
      end
      average_rating = total_ratings.to_f / @trips.length
      return average_rating
    end

    #Wave 2: Total_revenue
    def total_revenue
      fee = 1.65
      # total_revenue = 0
      @trips.map {|trip| trip.cost < fee ? 0 : trip.cost - fee}.sum * 0.8
    end

    #Wave 2: Loading All Drivers

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
end
# drivers =RideShare::Driver.load_all(full_path: '../support/drivers.csv')
# ap drivers