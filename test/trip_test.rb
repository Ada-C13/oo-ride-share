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
          id:99, 
          name: "Sam", 
          vin:"WBS76FYD47DJF7206"
        )
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

    it "raises an ArgumentError if end time is before start time" do
      new_end_time = Time.now- 120 * 60 # 120 minutes
      @trip_data[:end_time] = new_end_time
      expect{RideShare::Trip.new(@trip_data)}.must_raise ArgumentError
    end
  end

  describe 'duration' do
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
          id:99, 
          name: "Sam", 
          vin:"WBS76FYD47DJF7206"
        )
      }
      @trip = RideShare::Trip.new(@trip_data)
    end

    it "calculates the duration of the trip in seconds" do
      expect(@trip.duration).must_equal 1500
    end

    it "Returns a message when the trip is still in progress" do
      @test_data = {
        id: 5,
        passenger: RideShare::Passenger.new(
          id: 2,
          name: "Passenger 2",
          phone_number: "111-111-1111"
        ),
        start_time: Time.now,
        end_time: nil,
        rating: nil,
        driver: RideShare::Driver.new(
          id:1, 
          name: "Driver 1", 
          vin:"1B6CF40K1J3Y74UY0"
        )
      }
      @test_trip = RideShare::Trip.new(@test_data)

      expect(@test_trip.duration).must_equal "This trip is still in progress."
    end
  end
end
