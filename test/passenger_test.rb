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

      @driver = RideShare::Driver.new(
          id: 54,
          name: "Test Driver",
          vin: "12345678901234567",
          status: :AVAILABLE
        )

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
        rating: 5,
        driver: @driver
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

    it "adds up all costs of all trips" do
    #Arrange
    driver = RideShare::Driver.new(
      id: 54,
      name: "Rogers Bartell IV",
      vin: "1C9EVBRM0YBC564DZ"
    )
    passenger = RideShare::Passenger.new(
      id: 9,
      name: "Merl Glover III",
      phone_number: "1-602-620-2330 x3723",
      trips: []
      )
    trip = RideShare::Trip.new(
      id: 8,
      passenger: passenger,
      start_time: Time.new(2016, 8, 8),
      end_time: Time.new(2016, 8, 9),
      cost: 5,
      rating: 5,
      driver: driver
      )
    passenger.add_trip(trip)
    trip = RideShare::Trip.new(
      id: 8,
      passenger: passenger,
      start_time: Time.new(2016, 8, 8),
      end_time: Time.new(2016, 8, 9),
      cost: 7,
      rating: 5,
      driver: driver
      )
      passenger.add_trip(trip)

      #Act 
      total_cost_of_all_trips = passenger.net_expenditures

      #Assert
      expect(total_cost_of_all_trips).must_equal 12

    end
  end

    describe "total_time_spent" do
      it "adds up all the ride durations for a passenger" do
         #Arrange
         driver = RideShare::Driver.new(
          id: 54,
          name: "Rogers Bartell IV",
          vin: "1C9EVBRM0YBC564DZ"
        )
        passenger = RideShare::Passenger.new(
          id: 9,
          name: "Merl Glover III",
          phone_number: "1-602-620-2330 x3723",
          trips: []
          )
        trip = RideShare::Trip.new(
          id: 8,
          passenger: passenger,
          start_time: Time.new(2016, 8, 8),
          end_time: Time.new(2016, 8, 9),
          cost: 5,
          rating: 5,
          driver: driver
          )
        passenger.add_trip(trip)
        trip = RideShare::Trip.new(
          id: 8,
          passenger: passenger,
          start_time: Time.new(2016, 8, 8),
          end_time: Time.new(2016, 8, 9),
          cost: 7,
          rating: 5,
          driver: driver
          )
          passenger.add_trip(trip)

          #Act 
          total_time = passenger.total_time_spent

          #Assert
          expect(total_time).must_equal 172800
      end

      it "handles passengers with no trips" do
        # Arrange 
        passenger = RideShare::Passenger.new(
          id: 9,
          name: "Merl Glover III",
          phone_number: "1-602-620-2330 x3723",
          trips: [] #passenger has no trips
          )

        # Act 
        total_time = passenger.total_time_spent
        total_costs = passenger.net_expenditures

        #Assert
        expect(total_time).must_equal 0
        expect(total_costs).must_equal 0



    end



  end
end
