require_relative "test_helper"

describe "Passenger class" do
  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")
    end

    it "is an instance of Passenger" do
      expect(@passenger).must_be_kind_of RideShare::Passenger
    end

    it "throws an argument error with a bad ID value" do
      expect do
        RideShare::Passenger.new(id: 0, name: "Smithy")
      end.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      expect(@passenger.trips).must_be_kind_of Array
      expect(@passenger.trips.length).must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        expect(@passenger).must_respond_to prop
      end

      expect(@passenger.id).must_be_kind_of Integer
      expect(@passenger.name).must_be_kind_of String
      expect(@passenger.phone_number).must_be_kind_of String
      expect(@passenger.trips).must_be_kind_of Array
    end
  end

  describe "trips property" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        rating: 5,
        driver_id: 8,
      )

      @passenger.add_trip(trip)
    end

    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        expect(trip).must_be_kind_of RideShare::Trip
      end
    end

    it "all Trips must have the same passenger's passenger id" do
      @passenger.trips.each do |trip|
        expect(trip.passenger.id).must_equal 9
      end
    end
  end

  describe "net_expenditures" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.parse("2016-08-08"),
        end_time: Time.parse("2016-08-09"),
        rating: 5,
        cost: 7,
      )

      @passenger.add_trip(trip)

      trip2 = RideShare::Trip.new(
        id: 9,
        passenger: @passenger,
        start_time: Time.parse("2016-08-10"),
        end_time: Time.parse("2016-08-11"),
        rating: 5,
        cost: 9,
      )
      @passenger.add_trip(trip2)
    end

    it "calculates the total amount of money a passenger has spent on their trips" do
      expect(@passenger.net_expenditures).must_equal 16
    end

    # ! TODO fix this
    it "What happens if the passenger has no trips" do
      # @passenger.trips = nil
      # expect {
      #   @passenger.trips
      # }.must_raise ArgumentError
    end
  end

  describe "total_time_spent" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.parse("2016-08-08"),
        end_time: Time.parse("2016-08-09"), # difference 86400
        rating: 5,
        cost: 10,

      )
      @passenger.add_trip(trip)
      trip2 = RideShare::Trip.new(
        id: 9,
        passenger: @passenger,
        start_time: Time.parse("2016-08-10"),
        end_time: Time.parse("2016-08-11"), # difference 86400
        rating: 5,
        cost: 9,
      )
      @passenger.add_trip(trip2)

      # ! TODO check if we are calculating seconds
    end

    it "calculates total time spent on all rides for a passenger" do
      expect(@passenger.total_time_spent).must_equal 172800
    end

    it "What happens if the passenger has no trips" do
    end
  end
end
