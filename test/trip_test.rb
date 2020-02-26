require_relative 'test_helper'

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
        rating: 3,
        driver: RideShare::Driver.new(
          id: 1,
          name: "Paul Klee",
          vin: "WBS76FYD47DJF7206",
          status: :AVAILABLE
        ),
        driver_id: 1
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
      # Unskip after wave 2
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

    it "raises an error for end_time greater than start_time" do

  
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: Time.parse("2018-12-20 16:09:21 -0800"),
        end_time: Time.parse("2018-12-17 16:09:21 -0800"),
        cost: 23.45,
        rating: 3,
        driver_id: 2
      }
      
      expect{RideShare::Trip.new(@trip_data)}.must_raise ArgumentError
    end

  end

  describe "calculate_duration" do
    before do
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: Time.parse("12:00"),
        end_time: Time.parse("14:00"),
        cost: 23.45,
        rating: 3,
        driver_id: 2
      }
      @trip = RideShare::Trip.new(@trip_data)
    end

    it "wil calculate and return the time in seconds" do 
      expect(@trip.calculate_duration).must_equal 7200.0
    end

  end

end
