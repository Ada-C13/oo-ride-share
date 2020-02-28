require 'pry'
require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips 

    def initialize(id:, name:, vin:, status: :UNAVAILABLE, trips: nil)
     super(id)

      @name = name
      @vin = "" 
      @status = status #use guard clause in calling method 
      if !trips 
        @trips = []
      else 
        @trips = trips 
      end 
    end 

    def self.from_csv(record)
     return new(
       id:record[:id],
       name:record[:name],
       vin:record[:vin],
       status:record[:status]
      )
    end

    def add_trip(trip)
      @trips << trip
    end  

    def average_rating
      ave_rat = []
      @trips.each do |trip|
        ave_rat << trip.rating
      end
      average = ave_rat.sum / ave_rat.length
      return average
    end

  end 
end
RideShare::Driver.new(id: 123, name: "Donatello", vin: 123345398793, status: :AVAILABLE, trips: [])