require 'time'
require_relative 'test_helper'

TEST_DATA_DIRECTORY = 'test/test_data'

describe "TripDispatcher class" do
  def build_test_dispatcher
    return RideShare::TripDispatcher.new(
      directory: TEST_DATA_DIRECTORY
    )
  end

  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      dispatcher = build_test_dispatcher
      expect(dispatcher).must_be_kind_of RideShare::TripDispatcher
    end

    it "establishes the base data structures when instantiated" do
      dispatcher = build_test_dispatcher
      [:trips, :passengers, :drivers].each do |prop|
        expect(dispatcher).must_respond_to prop
      end

      expect(dispatcher.trips).must_be_kind_of Array
      expect(dispatcher.passengers).must_be_kind_of Array
      expect(dispatcher.drivers).must_be_kind_of Array
    end

    it "loads the development data by default" do
      # Count lines in the file, subtract 1 for headers
      trip_count = %x{wc -l 'support/trips.csv'}.split(' ').first.to_i - 1

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
        expect{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
      end

      it "finds a passenger instance" do
        passenger = @dispatcher.find_passenger(2)
        expect(passenger).must_be_kind_of RideShare::Passenger
      end

      it "finds the correct passenger" do
        passenger = @dispatcher.find_passenger(2)
        expect(passenger.name).must_equal "Passenger 2"
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

  describe "Requesting a Trip" do

    before do
      @dispatcher = build_test_dispatcher
      @requested_trip = @dispatcher.request_trip(8)
    end

    it "creates a new Trip instance" do
      expect(@requested_trip).must_be_kind_of RideShare::Trip
    end

    it "checks that end_time, cost, and rating are set to nil at initialization" do
      expect(@requested_trip.end_time).must_equal nil
      expect(@requested_trip.cost).must_equal nil
      expect(@requested_trip.rating).must_equal nil
    end

    it "raises an ArgumentError if passenger_id is not valid" do
      expect{@dispatcher.request_trip(0)}.must_raise ArgumentError
      expect{@dispatcher.request_trip(-2)}.must_raise ArgumentError
    end

    # Testing provided data (where most eligible driver had no trips)
    it "correctly finds the first available driver when the file has a driver with no trips" do
      expect(@requested_trip.driver.name).must_equal "Driver 3 (no trips)"
    end

    it "sets the selected driver's status to :UNAVAILABLE" do
      # expect(requested_trip).must_respond_to :status
      expect(@requested_trip.driver.status).must_equal :UNAVAILABLE
    end
  end
end


describe "Intelligent Dispatching Methods" do
  # New directory and data
  TEST_DATA_DIRECTORY2 = 'test_2/test_data'
  def build_test_dispatcher2
    return RideShare::TripDispatcher.new(
      directory: TEST_DATA_DIRECTORY2
    )
  end

  describe "available_drivers method" do
    
      before do
        @dispatcher2 = build_test_dispatcher2
        @requested_trip = @dispatcher2.request_trip(4)
      end

      it "returns an array when calling available_drivers" do
        expect(@dispatcher2.available_drivers).must_be_kind_of Array
      end

      it "returns the correct number of available drivers after running the method" do 
        previous_available_drivers = @dispatcher2.available_drivers
        expect(previous_available_drivers.length).must_equal 6

        #making sure when another driver is requested  
        #available drivers pool is decremented by one 
        @requested_trip2 = @dispatcher2.request_trip(5)

        current_available_drivers = @dispatcher2.available_drivers
        expect(current_available_drivers.length).must_equal 5
      end

      it "confirms that every driver in returned available drivers list has available status" do
        @requested_trip2 = @dispatcher2.request_trip(8)
        def check_all_statuses 
          @dispatcher2.available_drivers.each do |driver|
            if driver.status == :UNAVAILABLE
              return false
            else 
              return true
            end
          end
        end
        expect(check_all_statuses).must_equal true
      end
    end

    describe "pick_most_eligible_driver method" do
      
      # Modified provided data to test getting the driver with the oldest trip)
      before do
        @dispatcher2 = build_test_dispatcher2
        @requested_trip = @dispatcher2.request_trip(4)
      end

      it "correctly returns the driver who has not driven the longest" do
        expect(@requested_trip.driver.name).must_equal "Driver 9"
      end

      it "confirms that most eligible driver has a trip in progress" do
        expect(@requested_trip.end_time).must_be_nil
      end

      # After running another request_trip cycle, next most eligiible driver is found
      it "correctly returns the driver who has not driven the longest" do
        @requested_trip2 = @dispatcher2.request_trip(5)
        expect(@requested_trip2.driver.name).must_equal "Driver 2"
      end
  end
end 