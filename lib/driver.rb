require_relative 'csv_record'


module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips 

    def initialize(id:, name:, vin:, trips: nil, status: :AVAILABLE)
      super(id)
      @name = name
      @vin = vin
      @trips = trips || []
      @status = status
      status_options = [:AVAILABLE, :UNAVAILABLE]

      raise ArgumentError if @vin.length != 17 || @vin.class != String
      raise ArgumentError if !status_options.include?(status)
      raise ArgumentError if @id <= 0 || @id.class != Integer
    end 


    private 
    def self.from_csv(record)
      return self.new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status]
      )
    end 

  end 
end 
