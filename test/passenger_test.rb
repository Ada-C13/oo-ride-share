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

      driver = RideShare::Driver.new(
        id: 54,
        name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ",
        status: :AVAILABLE      
        )

      trip = RideShare::Trip.new(
        id: 8,
        driver: driver,
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

  # Test net_expenditures Method
  describe "net_expenditures" do

    before do
      # TODO: you'll need to add a driver at some point here.
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )

      driver = RideShare::Driver.new(
        id: 54,
        name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ",
        status: :AVAILABLE      
        )
  
      @trip1 = RideShare::Trip.new(
        id: 8,
        driver: driver,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        cost: 10,
        rating: 5
        )

      @trip2 = RideShare::Trip.new(
        id: 10,
        driver: driver,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 11),
        end_time: Time.new(2016, 8, 12),
        cost: 40,
        rating: 5
        )

      @trip3 = RideShare::Trip.new(
        id: 11,
        driver: driver,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 11) # removed end time, cost and rating
        )
      end

    it "Returns the total amount the passenger has spent on trips." do
      expect(@passenger.net_expenditures).must_equal 0
      expect(@passenger.net_expenditures).must_be_kind_of Numeric 
      @passenger.add_trip(@trip1)
      @passenger.add_trip(@trip2)
      expect(@passenger.net_expenditures).must_equal 50
    end

    it "net expenditure works with in-progress trips" do   #done
      @passenger.add_trip(@trip1)
      @passenger.add_trip(@trip2)
      @passenger.add_trip(@trip3)
      expect(@passenger.net_expenditures).must_equal 50 # no additional cost for trip 3

    end


  end

  describe "total_time_spent" do

    before do
      # TODO: you'll need to add a driver at some point here.
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )

      driver = RideShare::Driver.new(
        id: 54,
        name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ",
        status: :AVAILABLE      
        )
        
      @trip1 = RideShare::Trip.new(
        id: 8,
        driver: driver,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        cost: 10,
        rating: 5
        )

      @trip2 = RideShare::Trip.new(
        id: 10,
        driver: driver,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 11),
        end_time: Time.new(2016, 8, 12),
        cost: 40,
        rating: 5
        )

        @trip3 = RideShare::Trip.new(
        id: 11,
        driver: driver,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 11) # removed end time, cost and rating
        )
      end

    it "Returns the total time the passenger has had on trips." do
      expect(@passenger.total_time_spent).must_equal 0
      expect(@passenger.total_time_spent).must_be_kind_of Numeric 
      @passenger.add_trip(@trip1)
      @passenger.add_trip(@trip2)
      expect(@passenger.total_time_spent).must_equal 172800
    end

    it "total time spent works with in-progress trips" do # in construction... done
      @passenger.add_trip(@trip1)
      @passenger.add_trip(@trip2)
      @passenger.add_trip(@trip3)
      expect(@passenger.total_time_spent).must_equal 2 * 24 * 60 * 60 
    end

  end

  # Test total_time_spent Method
  describe "total_time_spent" do   # to think about, can this describe block be combined with the above one?
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone_number: "1-602-620-2330 x3723", trips: [])
      @trip1     = RideShare::Trip.new(id: 4, driver_id: 5, passenger: @passenger, start_time: Time.new(2016,8,1), end_time: Time.new(2016,8,2),rating: 5)
      @trip2     = RideShare::Trip.new(id: 8, driver_id: 5, passenger: @passenger, start_time: Time.new(2016,8,4), end_time: Time.new(2016,8,5),rating: 5)
    end

    it "returns the total time that passenger has spent on trips " do
      expect(@passenger.total_time_spent).must_be_kind_of Numeric
      expect(@passenger.total_time_spent).must_equal 0
      @passenger.add_trip(@trip1)
      expect(@passenger.total_time_spent).must_equal 24 * 60 * 60 # one day in seconds
      @passenger.add_trip(@trip2)
      expect(@passenger.total_time_spent).must_equal 2 * 24 * 60 * 60 # two days in seconds
    end
    

  end


end
