require 'csv'

require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord

    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id: nil, name: nil, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      @vin = vin
      @status = status
      @trips = trips || []

      case @status
      when :AVAILABLE
      when :UNAVAILABLE
      else
        raise ArgumentError.new("#{@status} is not a valid status.")
      end

      unless @vin.split(//).length == 17
        raise ArgumentError.new("#{@vin} is not a valid VIN number.")
      end


    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status]
      )
    end
  end
end
end