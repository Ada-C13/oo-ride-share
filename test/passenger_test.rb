require_relative 'test_helper'

describe "Passenger class" do
  before do #Created this driver to use across all passenger_test
    @driver = RideShare::Driver.new(
      id: 7,
      name: "Lak Kate",
      vin: "1C9YKKLR1BV5564A7",
      status: :AVAILABLE,
      trips: nil
    )
  end

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
        driver: @driver,
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
        id: 1,
        name: "Kate Lak",
        phone_number: "1-602-620-2330 x0723",
        trips: []
        )
      trip1 = RideShare::Trip.new(
        id: 1,
        driver: @driver,
        passenger: @passenger,
        start_time: Time.new(2020, 8, 8),
        end_time: Time.new(2020, 8, 9),
        cost: 100,
        rating: 5
        )  
      @passenger.add_trip(trip1)

      trip2 = RideShare::Trip.new(
        id: 2,
        driver: @driver,
        passenger: @passenger,
        start_time: Time.parse("2018-12-27 03:38:08 -0800"),
        end_time: Time.parse("2018-12-27 03:39:08 -0800"),
        cost: 200,
        rating: 5
        ) 
      @passenger.add_trip(trip2)
    end

    it 'add total expediture of the passenger object' do
      # passenger.trips.cost
      total = @passenger.net_expenditure
      expect(total).must_equal 300 
    end
  end

  describe "total_time_spent" do
    it "calculates the amount of time rider spent on trips" do

      driver = RideShare::Driver.new(id: 7, 
        name: "Test Driver", 
        vin: "12345678901234567")
      passenger = RideShare::Passenger.new(id: 1, 
        name: "Kate Lak", 
        phone_number: "1-602-620-2330 x0723", 
        trips: [])
      trip1 = RideShare::Trip.new(id: 1, 
        driver: driver, 
        passenger: passenger, 
        start_time: Time.parse("2018-12-27 03:38:08 -0800"),
        end_time: Time.parse("2018-12-27 03:39:08 -0800"), 
        cost: 100, 
        rating: 4) 
      passenger.add_trip(trip1)
      trip2 = RideShare::Trip.new(id: 2, 
        driver: driver, 
        passenger: passenger, 
        start_time: Time.parse("2018-12-27 02:38:08 -0800"),
        end_time: Time.parse("2018-12-27 02:40:08 -0800"), 
        cost: 200, 
        rating: 5) 
      passenger.add_trip(trip2)
      trip3 = RideShare::Trip.new(id: 2, 
        driver: driver, 
        passenger: passenger, 
        start_time: Time.parse("2018-12-27 04:38:08 -0800"),
        end_time: nil, 
        cost: 200, 
        rating: 5) 
      passenger.add_trip(trip3)

      expect(passenger.total_time_spent).must_equal 180
    end
  end
end