require_relative 'csv_record'
require 'csv'
require 'time'
require 'awesome_print'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :trips
    attr_accessor :status #Wave 3: overriding status in dispatch, need to make this attr accessor
    
    def initialize(
      id:,
      name:,
      vin:,
      status: :AVAILABLE,
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
      average_rating = 0
      total_trips = 0

      @trips.each do |trip|
        # if trip not in progress, add rating and increment trip
        if trip.end_time != nil 
          total_ratings += trip.rating
          total_trips += 1
        end
      end
      #orginally using length of trip but ran into NaN
      #now using total_trips that accounts for trips in progress
      if @trips.length > 0 
        average_rating = total_ratings.to_f / total_trips
      end

      return average_rating
    end

    #Wave 2: Total_revenue
    #Checked for in progress trip, if not in progress, then do total
    def total_revenue
      total_revenue = 0
      fee = 1.65
      @trips.each do |trip|
        if (trip.end_time != nil) && (trip.cost > fee)
            total_revenue += (trip.cost - fee) * 0.8
        end
      end
      return total_revenue
    end
# @trips.map {|trip| (trip.end_time != nil) && (trip.cost < fee) ? 0 : trip.cost - fee}.sum * 0.8

    # def self.find_driver_status(status)
    #   Driver.validate_id(status)
    #   drivers.each do |driver|
    #     if driver.status == :AVAILABLE
    #       return driver
    #     end
    #   end
    #   return nil
    # end
    
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

# puts Driver.find_driver_status("AVAILABLE")

