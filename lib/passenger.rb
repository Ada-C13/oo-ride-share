require_relative 'csv_record'
require 'time'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips

    def initialize(id:, name:, phone_number:, trips: nil)
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def net_expenditures #(passenger id?)
      # result = @trips.cost.sum
      return @trips.map {|trip| trip.cost}.sum
      #sum costs  #total amount of money pax as spent 

      # return @trips.map {|trip| trip.cost}.sum

    end

    private

    def self.from_csv(record)
      return self.new(
        id: record[:id],
        name: record[:name],
        phone_number: record[:phone_num]
      )
    end

  end
end

# # Add an instance method, net_expenditures, to Passenger that will return the total amount of money that passenger has spent on their trips
# def net_expenditures#(passenger id?)
#   restult = @trips.cost.sum
#   return result
#   #sum costs  #total amount of money pax as spent 
# end