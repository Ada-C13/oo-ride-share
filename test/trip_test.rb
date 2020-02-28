require_relative 'test_helper'

describe "Trip class" do
  describe "initialize" do
    before do
      start_time = Time.now - 60 * 60 # 60 minutes
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(
          id: 5, 
          name: "Driver 2", 
          vin: "1B6CF40K1J3Y74UY2"),
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

    it "raises an error if end_time is before start_time " do
      @trip_data[:start_time] = @trip_data[:end_time] + 15 * 60 # made start_time bigger than end_time by 15 minutes
      expect do
        RideShare::Trip.new(@trip_data)
      end.must_raise ArgumentError

      @trip_data[:start_time] = @trip_data[:end_time] + 1 # made start_time bigger than end_time by 1 second
      expect do
        RideShare::Trip.new(@trip_data)
      end.must_raise ArgumentError
    end

    it "calculates the duration of the trip corectly" do
      expect(@trip.duration).must_be_kind_of Float
      expect(@trip.duration).must_equal 1500.0
    end


    it "Allows a rating of nil" do
      @trip_data1 = {
        id: 8,
        driver_id: 5,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: nil,
        end_time: nil,
        cost: 23.45,
        rating: nil
      }
      @trip1 = RideShare::Trip.new(@trip_data1)
      expect(@trip1.rating).must_be_nil
      expect(@trip1.end_time).must_be_nil
    end
  end
end
