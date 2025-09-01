create schema if not exists Airlines;

create table if not exists Airlines.Booking_Agents(
Agent_id INT primary key, 
Agent_name VARCHAR(255),
Agent_details TEXT
);


create table Airlines.Passengers(
Passenger_id INT primary key,
First_name VARCHAR(150) not null,
Second_name VARCHAR(150),
Last_name VARCHAR(150) not null,
Phone_number VARCHAR(20),
Email_address VARCHAR(255) unique not null,
Address_lines VARCHAR(255),
City VARCHAR(150),
State_province_county VARCHAR(150),
Country VARCHAR(150),
Other_passenger_details TEXT
);

create table Airlines.Reservation_Status(
Reservation_status_code VARCHAR(15) primary key,
Description TEXT not null
);

create table Airlines.Ticket_type(
Ticket_type_code VARCHAR(15) primary key,
Description TEXT not null
);

create table Airlines.Ticket_Class(
Travel_class_code VARCHAR(15) primary key,
Description TEXT not null
);

create table Airlines.Itinerary_reservations(
Reservation_id INT primary key,
Agent_id INT null,
Passenger_id INT not null,
Reservation_status_code VARCHAR(15) not null,
Ticket_type_code VARCHAR(15) not null,
Travel_class_code VARCHAR(15) not null,
Date_reservation_made DATE not null,
Number_in_party int not null,
foreign key (Agent_id) references Airlines.Booking_Agents(Agent_id),
foreign key (Passenger_id) references Airlines.Passengers(Passenger_id), 
foreign key (Reservation_status_code) references Airlines.Reservation_Status(Reservation_status_code),
foreign key (Ticket_type_code) references Airlines.Ticket_type(Ticket_type_code),
foreign key (Travel_class_code) references Airlines.Ticket_Class(Travel_class_code)
);

create table Airlines.Payment_status(
Payment_status_code VARCHAR(15) primary key,
Description TEXT not null
);

create table Airlines.Payments(
Payment_id INT primary key,
Payment_status_code VARCHAR(15) not null,
Payment_date DATE not null,
Payment_amount DECIMAL(10,2) not null,
foreign key (Payment_status_code) references Airlines.Payment_status(Payment_status_code)
);


create table Airlines.Reservation_payments(
Reservation_id INT,
Payment_id INT,
primary key (Reservation_id, Payment_id),
foreign key (Reservation_id) references Airlines.Itinerary_reservations(Reservation_id),
foreign key (Payment_id) references Airlines.Payments(Payment_id)
);

create table Airlines.Airlines(
Airline_code VARCHAR(15) primary key,
Airline_name VARCHAR(255),
Description TEXT not null
);

create table Airlines.Aircraft_type(
Aircraft_type_code VARCHAR(15) primary key,
Description TEXT not null
);

create table Airlines.Ref_calendar(
Day_Date DATE primary key,
Day_number INT not null, 
Business_day_yn VARCHAR(5) not null
);

create table Airlines.Airports(
airport_code VARCHAR(15) primary key,
airport_name VARCHAR(255),
airport_location TEXT,
other_details TEXT
);

create table Airlines.Flight_schedules(
Flight_number VARCHAR(20) primary key,
Airline_code VARCHAR(15) not null,
Usual_aircraft_type_code VARCHAR(15) not null,
Origin_airport_code VARCHAR(15) not null,
Destination_airport_code VARCHAR(15) not null,
Departure_date_time TIMESTAMP not null,
Arrival_date_time TIMESTAMP not null,
Day_Date DATE not null,
foreign key (Airline_code) references Airlines.Airlines(Airline_code),
foreign key (Usual_aircraft_type_code) references Airlines.Aircraft_type(Aircraft_type_code), 
foreign key (Origin_airport_code) references Airlines.Airports(airport_code),
foreign key (Destination_airport_code) references Airlines.Airports(airport_code),
foreign key (Day_Date) references Airlines.Ref_calendar(Day_Date)
);

create table Airlines.Legs(
Leg_id INT primary key,
Flight_number VARCHAR(20) not null,
Origin_airport VARCHAR(15) not null,
Destination_airport VARCHAR(15) not null,
Actual_departure_time timestamp not null,
Actual_arrival_time timestamp not null,
foreign key (Flight_number) references Airlines.Flight_schedules(Flight_number),
foreign key (Origin_airport) references Airlines.Airports(airport_code),
foreign key (Destination_airport) references Airlines.Airports(airport_code)
);


create table Airlines.Itinerary_legs(
Reservation_id INT, 
Leg_id INT, 
primary key (Reservation_id, Leg_id),
foreign key (Reservation_id) references Airlines.Itinerary_reservations(Reservation_id),
foreign key (Leg_id) references Airlines.Legs(Leg_id)
);


create table Airlines.Flight_costs(
Flight_number VARCHAR(20),
Aircraft_type_code VARCHAR(15) not null,
valid_from_date DATE not null,
valid_to_date DATE not null,
flight_cost DECIMAL(10,2) not null,
primary key (Flight_number, aircraft_type_code, valid_to_date),
foreign key (Flight_number) references Airlines.Flight_schedules(Flight_number),
foreign key (Aircraft_type_code) references Airlines.Aircraft_type(Aircraft_type_code)
);





---Write the SQL queries/views for the highlighted requirements in section 2.3

--User Function-
---	View his itinerary:
create view Customer_Itinerary as 
select 
p. Passenger_id,
p. First_name,
p. Last_name,
ir.Reservation_id,
fs.Flight_number,
fs.Origin_airport_code,
fs.Destination_airport_code,
fs.Departure_date_time,
fs.Arrival_date_time,
ir.Number_in_party
from Airlines.Passengers p
join Airlines.Itinerary_reservations ir 
on  p.Passenger_id = ir.Passenger_id
join Airlines.Itinerary_legs il 
on ir.Reservation_id = il.Reservation_id
join Airlines.Legs l 
on il.Leg_id = l.Leg_id
join Airlines.Flight_schedules fs 
on l.Flight_number = fs.Flight_number;

--Employee Function-

---Get all customers who have seats reserved on a given flight:

create view Customer_attendance as 
select 
p. Passenger_id,
p. First_name,
p. Last_name,
ir.Reservation_id,
fs.Flight_number
from Airlines.Passengers p
join Airlines.Itinerary_reservations ir 
on  p.Passenger_id = ir.Passenger_id
join Airlines.Itinerary_legs il
on ir.Reservation_id = il.Reservation_id
join Airlines.Legs l 
on il.Leg_id = l.Leg_id
join Airlines.Flight_schedules fs 
on l.Flight_number = fs.Flight_number
where fs.Flight_number = 'flight_B613';

---Get all flights for a given airport:

create view Airport_flights as 
select 
fs.Flight_number,
fs.Origin_airport_code,
fs.Destination_airport_code,
fs.Departure_date_time
from Airlines.Flight_schedules fs
where fs.Origin_airport_code = 'LAX' 
or fs.Destination_airport_code = 'LAX';

---View flight schedule:

create view All_flight_schedules as 
select
fs.Flight_number,
ap1.airport_name as Origin_airport,
ap2.airport_name as Destination_airport,
fs.Departure_date_time,
fs.Arrival_date_time
from Airlines.Flight_schedules fs
join Airlines.Airports ap1 
on fs.Origin_airport_code = ap1.airport_code
join Airlines.Airports ap2
on fs.Destination_airport_code = ap2.airport_code
order by fs.Departure_date_time;

---Get all flights whose arrival and departure times are on time/delayed:

create view flight_delay_status as 
select
fs.Flight_number,
fs.Departure_date_time,
fs.Arrival_date_time,
case
		when fs.Departure_date_time > now() then 'scheduled'
		when fs.Arrival_date_time < now() then 'completed'
		else 'delayed'
	end as flight_delay_status
from Airlines.Flight_schedules fs

---Calculate total sales for a given flight:

create view flight_sales as 
select
fs.Flight_number,
sum(p.Payment_amount) as total_sales
from Airlines.Payments p
join Airlines.Reservation_payments rp 
on p.Payment_id = rp.Payment_id
join Airlines.Itinerary_reservations ir 
on rp.Reservation_id = ir.Reservation_id
join Airlines.Itinerary_legs il 
on ir.Reservation_id = il.Reservation_id
join Airlines.Legs l 
on il.Leg_id = l.Leg_id
join Airlines.Flight_schedules fs 
on l.Flight_number = fs.Flight_number
where fs.Flight_number = 'flight_B613'
group by fs.Flight_number;

