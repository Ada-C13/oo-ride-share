require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord

    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status:, trips: nil)
      super(id)

      @name = name
      @vin = vin

      if @vin.to_s.length != 17
        raise ArgumentError.new("Wrong length of vin!")
      end

      @status = status

      statuses = [:AVAILABLE, :UNAVAILABLE]
      if !statuses.include?@status.upcase.to_sym
        raise ArgumentError.new("Invalid status.")
      end
      
      
      @trips = [] || trips
    end
  end
end
