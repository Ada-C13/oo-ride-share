require_relative 'csv_record'

module RideShare
  class Driver << CsvRecord
    attr_reader :id, :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin:, status:, trips:)
      super(id)

      if vin.length != 17
        raise ArgumentError 'vin length has to be 17'
      end

      @name = name
      @vin = vin
      @status = status
      @trips = []
    end

    