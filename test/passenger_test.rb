require_relative 'test_helper'

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
      # TODO: you'll need to add a driver at some point here.
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        rating: 5
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
        trips: []
        )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        cost: 10,
        rating: 5
        )

      @passenger.add_trip(trip)
      @passenger.add_trip(trip)
      @passenger.add_trip(trip)
    end

    it "totals to $30 dollars for all trips" do
      expect(@passenger.net_expenditures).must_equal 30
    end
    
    it "totals to $55.50 dollars for all trips" do
      next_trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        cost: 25.50,
        rating: 5
        )
      @passenger.add_trip(next_trip)

      expect(@passenger.net_expenditures).must_equal 55.5
    end

    it "returns $0 if no trips have been taken" do
      @passenger_two = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )

      expect(@passenger_two.net_expenditures).must_equal 0
    end
  end

  describe "total_time_spent" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.parse("2020-02-25 15:00:00 -0800"),
        end_time: Time.parse("2020-02-25 16:00:00 -0800"),
        cost: 10,
        rating: 5
        )

      trip_two = RideShare::Trip.new(
        id: 9,
        passenger: @passenger,
        start_time: Time.parse("2020-02-25 15:00:00 -0800"),
        end_time: Time.parse("2020-02-25 17:00:00 -0800"),
        cost: 10,
        rating: 5
        )

      @passenger.add_trip(trip)
      @passenger.add_trip(trip_two)
    end

    it "totals time spent 10800.0" do
      expect(@passenger.total_time_spent).must_equal 10800.0
    end

    it "totals time spent 21600.0" do
      trip_three = RideShare::Trip.new(
        id: 10,
        passenger: @passenger,
        start_time: Time.parse("2020-02-25 15:00:00 -0800"),
        end_time: Time.parse("2020-02-25 18:00:00 -0800"),
        cost: 10,
        rating: 5
        )

      @passenger.add_trip(trip_three)

      expect(@passenger.total_time_spent).must_equal 21600.0
    end

    it "totals time spent 21900.0" do
      trip_three = RideShare::Trip.new(
        id: 10,
        passenger: @passenger,
        start_time: Time.parse("2020-02-25 15:00:00 -0800"),
        end_time: Time.parse("2020-02-25 18:00:00 -0800"),
        cost: 10,
        rating: 5
        )

      @passenger.add_trip(trip_three)

      trip_four = RideShare::Trip.new(
        id: 11,
        passenger: @passenger,
        start_time: Time.parse("2020-02-25 15:00:00 -0800"),
        end_time: Time.parse("2020-02-25 15:05:00 -0800"),
        cost: 10,
        rating: 5
        )

      @passenger.add_trip(trip_four)

      expect(@passenger.total_time_spent).must_equal 21900.0
    end
    
    it "totals 0 time spent if no trips are taken" do
      @passenger_two = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )
      expect(@passenger_two.total_time_spent).must_equal 0
    end
  end
end
