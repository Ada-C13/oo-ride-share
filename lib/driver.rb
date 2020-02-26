require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      @vin = vin
        if @vin.length != 17
          raise ArgumentError, "vin length must be 17 characters"
        end
      @status = status
      # if status does not equal :AVALIABLE || :UNAVAILABLE
      # raise ArgumentError, "status must be :available or un...
      # end"
      if !([:AVAILABLE, :UNAVAILABLE].include? @status) 
        raise ArgumentError, "status must be :AVAILABLE or :UNAVAILABLE"
      end
      
      @trips = trips || []
    end
  end
  
end