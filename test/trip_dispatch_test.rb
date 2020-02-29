require_relative "test_helper"

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

  # Wave 3: tests for request_trip method
  describe "request_trip" do
    it "returns instance of trip" do
      td = RideShare::TripDispatcher.new
      expect(td.request_trip(1)).must_be_kind_of RideShare::Trip
    end
    # Were the trip lists for the driver and passenger updated?
    it "Adds trip to passenger's trips" do
      dispatcher = build_test_dispatcher

      passenger = dispatcher.find_passenger(1)

      dispatcher.request_trip(1)

      expect(passenger.trips.length).must_equal 3

      # trip = added_trip
      # passenger.trips.last.id == trip.id
    end

    it "Adds trip to driver's trips" do
      dispatcher = build_test_dispatcher
      passenger = dispatcher.find_passenger(1)
      dispatcher.request_trip(1)

      # get the passenger's last trip
      passengers_last_trip = passenger.trips[-1]
      last_trips_driver = passengers_last_trip.driver_id
      driver = dispatcher.find_driver(last_trips_driver)

      expect(driver.trips.length).must_equal 5
    end

    it "Was the driver available" do
      dispatcher = build_test_dispatcher
      drivers = dispatcher.find_available_drivers
      passenger = dispatcher.find_passenger(1)
      dispatcher.request_trip(1)

      passengers_last_trip = passenger.trips[-1]
      last_trips_driver = passengers_last_trip.driver_id
      driver = dispatcher.find_driver(last_trips_driver)
      expect(drivers.include?(last_trips_driver)).must_equal false
      # count how many available driver
      # request trip
      # expect one less available driver

      expect(driver.status).must_equal :UNAVAILABLE
    end

    it "Raises ArgumentError for unavailable driver" do
      dispatcher = build_test_dispatcher
      dispatcher.drivers.each do |driver|
        driver.status = :UNAVAILABLE
      end
      expect {dispatcher.request_trip(1) }.must_raise ArgumentError
    end
    # Give dispatcher only unavailable drivers to raise ArgumentError - Set all driver to unavailable? Give one unavailable driver in drivers?
  end

  # TODO: un-skip for Wave 2
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
end

# Wave 3 TripDispatcher tests:

# Was the trip created properly?
# Were the trip lists for the driver and passenger updated?
# Was the driver who was selected AVAILABLE?
# What happens if you try to request a trip when there are no AVAILABLE drivers?

# Interaction with Waves 1 & 2
# One thing you may notice is that this change breaks your code from previous waves, possibly in subtle ways. We've added a new kind of trip, an in-progress trip, that is missing some of the values you need to compute those numbers.

# Your code from waves 1 & 2 should ignore any in-progress trips. That is to say, any trip where the end time is nil should not be included in your totals.

# You should also add explicit tests for this new situation. For example, what happens if you attempt to calculate the total money spent for a Passenger with an in-progress trip, or the average rating of a Driver with an in-progress trip?
