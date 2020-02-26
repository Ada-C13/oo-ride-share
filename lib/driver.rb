require_relative 'csv_record'


module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips 
    def initialize 
  end 
end 