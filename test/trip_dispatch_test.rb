require_relative "test_helper"
require "pry"

TEST_DATA_DIRECTORY = "test/test_data"

describe "TripDispatcher class" do
  def build_test_dispatcher
    return RideShare::TripDispatcher.new(
             directory: TEST_DATA_DIRECTORY,
           )
  end

  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      dispatcher = build_test_dispatcher
      expect(dispatcher).must_be_kind_of RideShare::TripDispatcher
    end

    it "establishes the base data structures when instantiated" do
      dispatcher = build_test_dispatcher
      [:trips, :passengers].each do |prop|
        expect(dispatcher).must_respond_to prop
      end

      expect(dispatcher.trips).must_be_kind_of Array
      expect(dispatcher.passengers).must_be_kind_of Array
      expect(dispatcher.drivers).must_be_kind_of Array
    end

    it "loads the development data by default" do
      # Count lines in the file, subtract 1 for headers
      trip_count = %x{wc -l 'support/trips.csv'}.split(" ").first.to_i - 1

      dispatcher = RideShare::TripDispatcher.new

      expect(dispatcher.trips.length).must_equal trip_count
    end
  end

  describe "passengers" do
    describe "find_passenger method" do
      before do
        @dispatcher = build_test_dispatcher
      end

      it "throws an argument error for a bad ID" do
        expect { @dispatcher.find_passenger(0) }.must_raise ArgumentError
      end

      it "finds a passenger instance" do
        passenger = @dispatcher.find_passenger(2)
        expect(passenger).must_be_kind_of RideShare::Passenger
      end
    end

    describe "Passenger & Trip loader methods" do
      before do
        @dispatcher = build_test_dispatcher
      end

      it "accurately loads passenger information into passengers array" do
        first_passenger = @dispatcher.passengers.first
        last_passenger = @dispatcher.passengers.last

        expect(first_passenger.name).must_equal "Passenger 1"
        expect(first_passenger.id).must_equal 1
        expect(last_passenger.name).must_equal "Passenger 8"
        expect(last_passenger.id).must_equal 8
      end

      it "connects trips and passengers" do
        dispatcher = build_test_dispatcher
        dispatcher.trips.each do |trip|
          expect(trip.passenger).wont_be_nil
          expect(trip.passenger.id).must_equal trip.passenger_id
          expect(trip.passenger.trips).must_include trip
        end
      end
    end
  end

  describe "drivers" do
    describe "find_driver method" do
      before do
        @dispatcher = build_test_dispatcher
      end

      it "throws an argument error for a bad ID" do
        expect { @dispatcher.find_driver(0) }.must_raise ArgumentError
      end

      it "finds a driver instance" do
        driver = @dispatcher.find_driver(2)
        expect(driver).must_be_kind_of RideShare::Driver
      end
    end

    describe "Driver & Trip loader methods" do
      before do
        @dispatcher = build_test_dispatcher
      end

      it "accurately loads driver information into drivers array" do
        first_driver = @dispatcher.drivers.first
        last_driver = @dispatcher.drivers.last

        expect(first_driver.name).must_equal "Driver 1 (unavailable)"
        expect(first_driver.id).must_equal 1
        expect(first_driver.status).must_equal :UNAVAILABLE
        expect(last_driver.name).must_equal "Driver 3 (no trips)"
        expect(last_driver.id).must_equal 3
        expect(last_driver.status).must_equal :AVAILABLE
      end

      it "connects trips and drivers" do
        dispatcher = build_test_dispatcher
        dispatcher.trips.each do |trip|
          expect(trip.driver).wont_be_nil
          expect(trip.driver.id).must_equal trip.driver_id
          expect(trip.driver.trips).must_include trip
        end
      end
    end
  end

  describe "request_trip method" do
    before do
      @dispatcher = build_test_dispatcher
      start_time = Time.now
      end_time = nil
      @trip_data = {
        id: 6,
        driver: @dispatcher.drivers[2], # first available driver in our test data
        passenger: @dispatcher.passengers.first, # first passenger in our test data
        start_time: start_time,
        end_time: end_time,
        cost: nil,
        rating: nil,
      }
      # Create an instance of a trip that will be a mirror of test_trip
      @expected_trip = RideShare::Trip.new(@trip_data)

      # Create instance of a trip using request_trip method
      @test_trip = @dispatcher.request_trip(@expected_trip.passenger.id)
    end

    let (:trip_w_no_driver) {
        RideShare::Trip.new(
          id: 6,
          driver: nil, 
          passenger: @dispatcher.passengers.first, # first passenger in our test data
          start_time: Time.now,
          end_time: nil,
          cost: nil,
          rating: nil
        )
        }
    
    it "check to see if there is an intance of Trip" do
      expect(@test_trip).must_be_kind_of RideShare::Trip
    end
    it "gets an instance of passenger when given an id" do
      expect(@test_trip.passenger).must_be_kind_of RideShare::Passenger
    end
    it "The passenger instance ID must match the passenger_id given as a paramteter" do
      expect(@test_trip.passenger.id).must_equal @expected_trip.passenger_id
    end
    it "gets an instance of first available driver" do
      expect(@test_trip.driver_id).must_equal 2
      expect(@test_trip.driver).must_be_kind_of RideShare::Driver
    end
    it "check to see if trip start_time is valid" do
      expect(@test_trip.start_time).wont_be_nil
    end
    it "checks to see if the trip end time, cost, and rating is nil" do
      expect(@test_trip.end_time).must_be_nil
      expect(@test_trip.cost).must_be_nil
      expect(@test_trip.rating).must_be_nil
    end
    # test_trip is appended to both the Passenger and Driver's trip arrays
    it "updates the passenger's trips to add the current trip" do
      expect(@test_trip.passenger.trips.last.id).must_equal @expected_trip.id
    end
    it "updates the driver's trips to add the current trip" do
      expect(@test_trip.driver.trips.last.id).must_equal @expected_trip.id
    end
    it "raises an ArgumentError when there are no drivers available" do
      expect{request_trip(trip_w_no_driver.passenger.id)}.must_raise ArgumentError
    end
    it "driver's status is switched from available to unavailable" do
      expect(@test_trip.driver.status).must_equal :UNAVAILABLE
    end
  end
end
