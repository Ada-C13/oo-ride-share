require_relative 'csv_record'

module RideShare 
  class Driver < CsvRecord 
    attr_reader :id, :name, :vin, :status, :trips 
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil) 
      super(id)

      if ![:AVAILABLE, :UNAVAILABLE].include?(status)
        raise ArgumentError.new("#{status} is an invalid status.")
      end 

      if vin.length != 17 
        raise ArgumentError.new("VIN has the wrong length.")
      end 

      @name = name
      @vin = vin 
      @status = status
      @trips = trips || [] 
    end 

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym
      )
    end
  end 
end 
