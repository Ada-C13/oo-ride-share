require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord

  attr_reader :name, :vin, :trips, :status
  

  def initialize (id:, name:, vin:, status: :AVAILABLE, trips: nil)
    super(id)

    @name = name
    @vin = vin
    @status = status
    @trips = trips || []
  
    vin_pattern = /^[A-Z0-9]{17}$/i
    if (vin_pattern =~ @vin) == nil
      raise ArgumentError, "Invalid VIN"
    end

  end

  end
end
