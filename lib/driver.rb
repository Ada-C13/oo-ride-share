require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:,name:,vin: ,status: :AVAILABLE ,trips: nil)
      super(id)

      @name = name
      @vin = vin
      @status = status 
      @trips = trips || []

      if @vin.length != 17
        raise ArgumentError, 'vin: #{@vin} is not valid'
      end 
      
      if (@status == :AVAILABLE || @status == :UNAVAILABLE) == false 
        raise ArgumentError, 'status:#{@status} is not a valid status'
      end 

      
    end

    private

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