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
          id: 54,
          name: "Test Driver",
          vin: "12345678901234567",
          status: :AVAILABLE
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

    it "raises an error if start time before end time" do
      @trip_data[:start_time] = @trip_data[:end_time] + 60
      expect{RideShare::Trip.new(@trip_data)}.must_raise ArgumentError
    end

    it "calculates trip duration correctly" do
      @trip_data[:end_time] = @trip_data[:start_time] + 60
      trip_duration = RideShare::Trip.new(@trip_data)
      expect(trip_duration.duration).must_equal 60
    end

    it "will raise ArugmentError if there is negative income" do
      [-1, -10].each do |cost|
        @trip_data[:cost] = cost
        expect do
          RideShare::Trip.new(@trip_data)
        binding.pry
        end.must_raise ArgumentError
      end
    end
  end
end
