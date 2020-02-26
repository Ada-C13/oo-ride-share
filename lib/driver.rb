require 'csv'

require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status:, trips: nil)
      super(id)

        @id = id
        @name = name
        @vin = vin
        @status = status
        @trips =trips || []


    end





  end
end
