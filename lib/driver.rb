require 'csv'
require_relative 'csv_record'

module RideShare
    class Driver < CsvRecord
        attr_reader :id, :name, :vin, :status, :trips 
        def initialize(id:, name:, vin:, status:, trips:)
            super(id)

            @name = name
            raise(ArgumentError, "This VIN exceeds more than 17 characters") if vin.length > 17
            @vin = vin
        end

    end
end
