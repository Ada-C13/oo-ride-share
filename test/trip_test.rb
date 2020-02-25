require_relative 'test_helper'
require 'time'


describe "Trip class" do
  describe "initialize" do
    before do
      start_time = Time.now - 60 * 60 # 60 minutes
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
      @trip = RideShare::Trip.new(@trip_data)
    end




    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "stores an instance of passenger" do
      expect(@trip.passenger).must_be_kind_of RideShare::Passenger
    end

    it "stores an instance of driver" do
      skip # Unskip after wave 2
      expect(@trip.driver).must_be_kind_of RideShare::Driver
    end

    it "raises an error for an invalid rating" do
      [-3, 0, 6].each do |rating|
        @trip_data[:rating] = rating
        expect do
          RideShare::Trip.new(@trip_data)
        end.must_raise ArgumentError
      end
    end

  end 

  describe 'initialize method' do
    it "must raise an argument error if end time is greater than start time" do 
      start_time = Time.new("2018-12-27 02:39:05 -0800")
      end_time = Time.new("2018-12-27 02:29:05 -0800")
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
     
      
      expect{RideShare::Trip.new(@trip_data)}.must_raise ArgumentError
    end 
  end 

  describe 'calculate_seconds' do 
    it 'calcuates seconds correctly' do 

      start_time = Time.parse("2018-12-27 02:39:05 -0800")
      end_time = Time.parse("2018-12-27 02:49:05 -0800")
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
      seconds = RideShare::Trip.new(@trip_data).calculate_seconds

      expect(seconds).must_equal 600.0
    end 
  end 
  
end
