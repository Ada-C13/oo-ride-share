require_relative "test_helper"

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
          phone_number: "412-432-7640",
        ),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3,
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

    it "Raises an error if the end time is before the start time" do
      @trip_data[:start_time] = Time.now - 60 * 60 # 60 minutes
      @trip_data[:end_time] = @trip_data[:start_time] - 25 * 60 # 25 minutes

      expect do
        RideShare::Trip.new(@trip_data)
      end.must_raise ArgumentError
    end

    it "calculate the duration of the trip in seconds" do
      expect(@trip.duration).must_equal 1500 #seconds
    end
  end
end
