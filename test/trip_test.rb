require_relative 'test_helper'

describe "Trip class" do
  describe "initialize" do
    before do
      start_time = Time.now - 60 * 60 # 60 minutes
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(
          id: 2,
          name: "Yesenia",
          vin: "08041995YSB",
          status: :AVAILABLE  
        ),
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

    let (:bad_trip) {
      start_time = Time.now - 60 * 60 # 60 minutes
      end_time = start_time - 1
      trip_data = {
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
      trip = RideShare::Trip.new(trip_data)     
    }

    it "raises an argument error if end time is before start time" do 
      expect {bad_trip}.must_raise ArgumentError
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

    # it "raises an error for an invalid rating" do
    #   [-3, 0, 6].each do |rating|
    #     @trip_data[:rating] = rating
    #     expect do
    #       RideShare::Trip.new(@trip_data)
    #     end.must_raise ArgumentError
    #   end
    # end
    # it "return the correct duration time of a trip" do 
    #   duration = @trip.end_time - @trip.start_time
    #   expect(duration.to_i).must_equal 25 * 60 #25 mins (the difference) * seconds since this is in seconds 
    # end
  end
end
