CREATE DATABASE CinemaDatabase;
GO
-------------------------------------------------------------------
-- 1) Creating the table
CREATE TABLE movie (
    movie_id INT IDENTITY(1,1) PRIMARY KEY,
    title NCHAR(60) NOT NULL,
    release_year  SMALLINT NOT NULL CHECK (release_year  >= 0),
    language NCHAR(50) NOT NULL,
    duration SMALLINT NOT NULL CHECK (duration >= 0),
    country NCHAR(50) NOT NULL,
    subtitles NCHAR(3) NOT NULL CHECK (subtitles IN ('YES', 'NO')),
    age_restriction NCHAR(4) NOT NULL CHECK (age_restriction IN ('16', '18', '12', 'None'))
);
-------------------------------------------------------------------
-- 1) Creating the actor
CREATE TABLE actor (
    actor_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NCHAR(50) NOT NULL,
    last_name NCHAR(50) NOT NULL,
    gender CHAR(1) NOT NULL CHECK (gender = 'M' OR gender = 'F'),
    date_of_birth DATE,
    nationality NCHAR(50),
    place_of_birth NCHAR(50)
);
-------------------------------------------------------------------
CREATE TABLE director (
    director_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NCHAR(50) NOT NULL,
    last_name NCHAR(50) NOT NULL,
    gender CHAR(1) NOT NULL CHECK (gender = 'M' OR gender = 'F'),
    date_of_birth DATE,
    nationality NCHAR(50),
    place_of_birth NCHAR(50)
);
-------------------------------------------------------------------
CREATE TABLE role (
    actor_id INT NOT NULL,
    movie_id INT NOT NULL,
    role_name NCHAR(50) NOT NULL,
    CONSTRAINT role_actor FOREIGN KEY (actor_id) REFERENCES actor(actor_id)
    ON DELETE NO ACTION,
    CONSTRAINT role_movie FOREIGN KEY (movie_id) REFERENCES movie(movie_id)
    ON DELETE NO ACTION
);
-------------------------------------------------------------------
CREATE TABLE movie_direction (
    director_id INT NOT NULL,
    movie_id INT NOT NULL,
    CONSTRAINT movie_direction_director FOREIGN KEY (director_id) REFERENCES director(director_id)
    ON DELETE NO ACTION,
    CONSTRAINT movie_direction_movie FOREIGN KEY (movie_id) REFERENCES movie(movie_id)
    ON DELETE NO ACTION
);
-------------------------------------------------------------------
CREATE TABLE genres (
    genre_id INT IDENTITY(1,1) PRIMARY KEY,
    name NCHAR(40) NOT NULL UNIQUE
);
-------------------------------------------------------------------
CREATE TABLE movie_genre (
    movie_id INT NOT NULL,
    genre_id INT NOT NULL,
    CONSTRAINT movie_genre_movie FOREIGN KEY (movie_id) REFERENCES movie(movie_id)
    ON DELETE NO ACTION,
    CONSTRAINT movie_genre_genre FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
    ON DELETE NO ACTION
);
-------------------------------------------------------------------
CREATE TABLE halls (
    hall_id INT IDENTITY(1,1) PRIMARY KEY,
    hall_name NCHAR(25) NOT NULL UNIQUE
);
-------------------------------------------------------------------
CREATE TABLE screenings (
    screening_id INT IDENTITY(1,1) PRIMARY KEY,
    movie_id INT NOT NULL,
    hall_id INT NOT NULL,
    screening_date SMALLDATETIME NOT NULL,
    CONSTRAINT screenings_movie FOREIGN KEY (movie_id) REFERENCES movie(movie_id)
    ON DELETE NO ACTION,
    CONSTRAINT screenings_hall FOREIGN KEY (hall_id) REFERENCES halls(hall_id)
    ON DELETE NO ACTION
);
-------------------------------------------------------------------
CREATE TABLE rows_seat (
    row_id INT IDENTITY(1,1) PRIMARY KEY,
    row_label CHAR NOT NULL CHECK (row_label IN ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N')) UNIQUE
);
-------------------------------------------------------------------
CREATE TABLE seats (
    seat_id INT IDENTITY(1,1) PRIMARY KEY,
    seat_number INT NOT NULL CHECK (seat_number BETWEEN 1 AND 20) UNIQUE
);
-------------------------------------------------------------------
CREATE TABLE seat_location (
    seat_location_id INT IDENTITY(1,1) PRIMARY KEY,
    hall_id INT NOT NULL,
    row_id INT NOT NULL,
    seat_id INT NOT NULL,
    CONSTRAINT seat_location_hall FOREIGN KEY (hall_id) REFERENCES halls(hall_id)
    ON DELETE NO ACTION,
    CONSTRAINT seat_location_row FOREIGN KEY (row_id) REFERENCES rows_seat(row_id)
    ON DELETE NO ACTION,
    CONSTRAINT seat_location_seat FOREIGN KEY (seat_id) REFERENCES seats(seat_id)
    ON DELETE NO ACTION
);
-------------------------------------------------------------------
CREATE TABLE personal_data (
    personal_data_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NCHAR(50) NOT NULL,
    last_name NCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    email NCHAR(50) CHECK (email LIKE '%@%.%')
);
-------------------------------------------------------------------
CREATE TABLE customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    personal_data_id INT NOT NULL,
    CONSTRAINT customers_personal_data FOREIGN KEY (personal_data_id)
    REFERENCES personal_data(personal_data_id)
    ON DELETE NO ACTION
);
-------------------------------------------------------------------
CREATE TABLE tickets (
    ticket_id INT IDENTITY(1,1) PRIMARY KEY,
    screening_id INT NOT NULL,
    customer_id INT NOT NULL,
    seat_location_id INT NOT NULL,
    purchase_date SMALLDATETIME NOT NULL,
    CONSTRAINT tickets_screening FOREIGN KEY (screening_id) REFERENCES screenings(screening_id)
    ON DELETE NO ACTION,
    CONSTRAINT tickets_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON DELETE NO ACTION,
    CONSTRAINT tickets_seat_location FOREIGN KEY (seat_location_id) REFERENCES seat_location(seat_location_id)
    ON DELETE NO ACTION
);
-------------------------------------------------------------------
INSERT INTO movie (title, release_year, language, duration, country, subtitles, age_restriction)
VALUES ('The House That Jack Built', 2018, 'English', 155, 'Denmark', 'YES', '18'),
       ('Titanic', 1997, 'English', 194, 'USA', 'YES', '16'),
       ('Avatar', 2009, 'English', 162, 'USA', 'YES', '12'),
       ('The Wolf of Wall Street', 2013, 'English', 180, 'USA', 'YES', '18'),
       ('Gladiator', 2000, 'English', 120, 'USA', 'YES', '16'),
       ('The Aviator', 2004, 'English', 116, 'USA', 'YES', '12'),
       ('The Last Samurai', 2003, 'English', 143, 'USA', 'YES', '16'),
       ('Suspiria', 2018, 'English', 108, 'USA', 'YES', '18'),
       ('Interstellar', 2014, 'English', 155, 'USA', 'YES', '12'),
       ('The Shawshank Redemption', 1994, 'English', 142, 'USA', 'YES', 'NONE');
-------------------------------------------------------------------
INSERT INTO actor (first_name, last_name, gender, date_of_birth, nationality, place_of_birth)  
VALUES ('Christian', 'Bale', 'M', '1974-01-30', 'USA', 'Haverfordwest'),  
('Matthew', 'McConaughey', 'M', '1969-11-04', 'USA', 'Uvalde'),  
('Leonardo', 'DiCaprio', 'M', '1974-11-11', 'USA', 'Los Angeles'),  
('Brad', 'Pitt', 'M', '1963-12-18', 'USA', 'Shawnee'),  
('Naomi', 'Watts', 'F', '1968-09-28', 'United Kingdom', 'Shoreham'),  
('Kate', 'Winslet', 'F', '1975-10-05', 'United Kingdom', 'Reading'),  
('Russell', 'Crowe', 'M', '1964-04-07', 'Australia', 'Wellington'),  
('Morgan', 'Freeman', 'M', '1937-06-01', 'USA', 'Memphis');
-------------------------------------------------------------------
INSERT INTO director (first_name, last_name, gender, date_of_birth, nationality, place_of_birth)  
VALUES ('Steven', 'Spielberg', 'M', '1946-12-18', 'USA', 'Cincinnati'),  
('David', 'Lynch', 'M', '1946-01-20', 'USA', 'Missoula'),  
('Christopher', 'Nolan', 'M', '1970-07-30', 'United Kingdom', 'Westminster'),  
('James', 'Cameron', 'M', '1954-08-16', 'Canada', 'Kapuskasing'),  
('Ridley', 'Scott', 'M', '1937-11-30', 'United Kingdom', 'South Shields');  
-------------------------------------------------------------------
INSERT INTO role (actor_id, movie_id, role_name)  
VALUES (2, 9, 'Cooper'),  
(2, 4, 'Mark Hanna'),  
(3, 2, 'Jack Dawson'),  
(3, 4, 'Jordan Belfort'),  
(3, 6, 'Howard Hughes'),  
(6, 2, 'Rose Bukater'),  
(8, 10, 'Red');  
-------------------------------------------------------------------
INSERT INTO movie_direction (director_id, movie_id)  
VALUES (3, 9),  
(4, 2),  
(4, 3),  
(5, 5);  
-------------------------------------------------------------------
INSERT INTO personal_data (first_name, last_name, date_of_birth, email)  
VALUES ('Marian', 'Nowak', '1990-10-10', 'marian_nowak@gmail.com'),  
('Tomasz', 'Kwiatkowski', '1980-12-14', 't_kwiatkowski@gmail.com'),  
('Jan', 'Lewandowski', '1995-12-22', 'jan_lewandowski223@gmail.com'),  
('Marcin', 'Nowak', '1992-10-10', 'marcin_nowak92@gmail.com'),  
('Marian', 'Kwiatkowski', '1991-10-15', 'marian_kwiatkowski@o2.com'),  
('Michał', 'Piątek', '1994-10-10', 'mpiatek@gmail.com'),  
('Marcin', 'Gryza', '1992-09-10', 'marcing92@o2.com');  
-------------------------------------------------------------------
INSERT INTO customers (personal_data_id)  
VALUES (1),  
(2),  
(3),  
(4),  
(5),  
(6),  
(7); 
-------------------------------------------------------------------
INSERT INTO genres (name)  
VALUES ('Drama'),  
('Horror'),  
('Science Fiction'),  
('Thriller'),  
('Comedy'),  
('Melodrama'),  
('Documentary'),  
('Psychological'),  
('Action'),  
('Fantasy');  
-------------------------------------------------------------------
INSERT INTO movie_genre (movie_id, genre_id)  
VALUES (1, 8),  
(2, 6),  
(3, 10),  
(4, 5),  
(5, 1),  
(6, 1),  
(7, 1),  
(8, 2),  
(9, 1),  
(10, 3); 
-------------------------------------------------------------------
INSERT INTO rows_seat (row_label)  
VALUES ('A'),  
('B'),  
('C'),  
('D'),  
('E'),  
('F'),  
('G'),  
('H'),  
('I'),  
('J'),  
('K'),  
('L'),  
('M'),  
('N');  

-------------------------------------------------------------------
INSERT INTO seats (seat_number)  
VALUES (20),  
(11),  
(14),  
(15),  
(1),  
(5),  
(3),  
(12),  
(16),  
(6),  
(4),  
(2),  
(7),  
(9),  
(19),  
(18);  
-------------------------------------------------------------------
INSERT INTO halls (hall_name)  
VALUES ('Toronto'),  
('London'),  
('Warsaw'),  
('Rome'),  
('New York'),  
('Beijing'),  
('Brussels'),  
('Amsterdam');  
-------------------------------------------------------------------
INSERT INTO seat_location (hall_id, row_id, seat_id)  
VALUES (1,1,1),  
(2,2,2),  
(3,3,3),  
(4,4,5),  
(5,5,4),  
(6,6,7),  
(7,7,6),  
(1,8,8),  
(2,9,9),  
(3,10,10),  
(4,11,11),  
(5,12,12),  
(6,13,13),  
(7,14,14); 
-------------------------------------------------------------------
INSERT INTO screenings (movie_id, hall_id, screening_date)  
VALUES (1,2, '2018-02-01 12:00:00'),  
(2,1, '2018-02-01 12:30:00'),  
(2,3, '2018-02-03 12:00:00'),  
(3,2, '2018-02-04 14:30:00'),  
(5,1, '2018-02-03 16:00:00'),  
(4,3, '2018-02-03 17:30:00'),  
(7,2, '2018-02-09 20:00:00'),  
(9,4, '2018-02-04 23:30:00'),  
(5,4, '2018-02-05 12:00:00'),  
(2,1, '2018-02-04 20:00:00'),  
(4,2, '2018-02-05 23:15:00');  
-------------------------------------------------------------------
INSERT INTO tickets (screening_id, customer_id, seat_location_id, purchase_date)  
VALUES (1, 4, 1, '2018-01-22 20:00:00'),  
(2, 5, 2, '2018-01-24 12:00:00'),  
(3, 6, 3, '2018-01-23 12:00:00'),  
(4, 7, 4, '2018-01-22 23:00:00'),  
(5, 1, 5, '2018-01-26 22:00:00'),  
(6, 2, 6, '2018-01-23 16:00:00'),  
(7, 3, 7, '2018-01-28 18:00:00'),  
(8, 4, 8, '2018-01-30 20:00:00'),  
(9, 5, 9, '2018-01-22 17:00:00'),  
(10, 3, 10, '2018-01-25 20:00:00'),  
(8, 2, 11, '2018-01-23 16:00:00'),  
(8, 6, 12, '2018-01-28 18:00:00'),  
(2, 1, 13, '2018-01-30 20:00:00'),  
(1, 2, 14, '2018-01-22 17:00:00'),  
(8, 3, 1, '2018-01-25 20:00:00'),  
(11, 4, 2, '2018-01-27 20:00:00'); 
-------------------------------------------------------------------
--Print out the table of people whose email contains 'o2'.
select personal_data.first_name as FirstName, 
	   personal_data.last_name as LastName,
	   personal_data.email as 'E-mail'
from personal_data 
where personal_data.email LIKE '%o2%'
order by personal_data.first_name asc;
-------------------------------------------------------------------
--Print out the information of people who watched the movie Interstellar.
select personal_data.first_name as FirstName,
	   personal_data.last_name as LastName,
	   movie.title as Movie,
	   screenings.screening_date as 'Screening Date'
from personal_data 
join customers on personal_data.personal_data_id = customers.customer_id
join tickets on customers.customer_id = tickets.customer_id
join screenings on tickets.screening_id = screenings.screening_id
join movie on screenings.movie_id = movie.movie_id
where movie.title = 'Interstellar'
order by personal_data.first_name asc
-------------------------------------------------------------------
--View screening times for movies in the Drama and Comedy genres.
select movie.title as Movie,
       genres.name as Genre, 
	   screenings.screening_date as 'Screening Date'
from screenings
join movie on screenings.movie_id = movie.movie_id
join movie_genre on movie.movie_id = movie_genre.movie_id
join genres on movie_genre.genre_id = genres.genre_id 
where genres.name = 'Drama' or genres.name = 'Comedy'
order by screenings.screening_date asc;
-------------------------------------------------------------------
--Determine the screening schedule of movies that fall between two specific dates.
select movie.title as Movie, 
	   halls.hall_name as Halls, 
	   genres.name as Genre,
	   datename(weekday, screenings.screening_date) as 'Day of the Week',
	   screenings.screening_date as 'Date'
from screenings
join movie on screenings.movie_id = movie.movie_id 
join movie_genre on movie.movie_id = movie_genre.movie_id
join genres on movie_genre.genre_id = genres.genre_id 
join halls on screenings.hall_id = halls.hall_id
where screenings.screening_date between '2018-02-03' and '2018-02-05' 
order by screenings.screening_date asc;

-------------------------------------------------------------------
--Statistics on the number of movies each person has watched
select personal_data.first_name as First_Name, 
       personal_data.last_name as Last_Name, 
       personal_data.date_of_birth as 'Date of Birth', 
       personal_data.email as 'E-mail', 
       count(screenings.movie_id) as 'Number of Screenings'
from personal_data
join customers on personal_data.personal_data_id = customers.personal_data_id
join tickets on customers.customer_id = tickets.customer_id
join screenings on tickets.screening_id = screenings.screening_id
join movie on screenings.movie_id = movie.movie_id
group by personal_data.first_name, personal_data.last_name, personal_data.date_of_birth, personal_data.email
order by personal_data.first_name asc;
-------------------------------------------------------------------
--Statistics on movie ticket booking information of customers
select personal_data.first_name as First_Name, 
       personal_data.last_name as Last_Name, 
       movie.title as Movie, 
       format(screenings.screening_date, 'MM - dd') as 'Month - Day', 
       format(screenings.screening_date, 'HH:mm') as 'Time', 
       seats.seat_number as 'Seat Number', 
       rows_seat.row_label as 'Row'
from personal_data
join customers on personal_data.personal_data_id = customers.personal_data_id
join tickets on customers.customer_id = tickets.customer_id
join screenings on tickets.screening_id = screenings.screening_id
join movie on screenings.movie_id = movie.movie_id
join seat_location on tickets.seat_location_id = seat_location.seat_location_id
join seats on seat_location.seat_id = seats.seat_id
join rows_seat on seat_location.row_id = rows_seat.row_id
order by personal_data.first_name asc;
-------------------------------------------------------------------
select * from [dbo].[movie]
select * from [dbo].[actor]
select * from [dbo].[director]
select * from [dbo].[role]
select * from [dbo].[movie_direction]
select * from [dbo].[personal_data]
select * from [dbo].[customers]
select * from [dbo].[genres]
select * from [dbo].[movie_genre]
select * from [dbo].[rows_seat]
select * from [dbo].[seats]
select * from [dbo].[halls]
select * from [dbo].[seat_location]
select * from [dbo].[screenings]
select * from [dbo].[tickets]


