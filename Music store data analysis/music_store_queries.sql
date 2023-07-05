use music_database

--1 
SELECT TOP 1 *
FROM employee
ORDER BY levels DESC;

--2 
select count(*) as c , billing_country
from invoice 
group by billing_country
order by c desc 

--3
select top 3 *
from invoice 
order by total desc 

--4
select sum(total) as invoice_total ,billing_city
from invoice 
group by billing_city 
order by invoice_total desc 

--5
Select top 1 customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) as total
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id, customer.first_name, customer.last_name
order by total DESC;

--SET 2 [ moderate questions ]
--6
SELECT distinct email , first_name , last_name 
from customer 
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in (
select track_id from track 
join genre on track.genre_id = genre.genre_id
where genre.name like 'Rock')
order by email;


--7
SELECT TOP 10 artist.artist_id, artist.name, COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id, artist.name
ORDER BY number_of_songs DESC;

--8

select name,milliseconds 
from track 
where milliseconds > (
select avg (milliseconds) as avg_track_length
from track)
order by milliseconds desc ; 

--Hard Questions 

--9
WITH best_selling_artist AS (
    SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
    FROM invoice_line
    JOIN track ON track.track_id = invoice_line.track_id
    JOIN album ON album.album_id = track.album_id
    JOIN artist ON artist.artist_id = album.artist_id
    GROUP BY artist.artist_id, artist.name
    ORDER BY total_sales DESC
    OFFSET 0 ROWS -- Equivalent to removing LIMIT in SSMS
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY c.customer_id, c.first_name, c.last_name, bsa.artist_name
ORDER BY amount_spent DESC;

--10 
WITH popular_genre AS 
(
    SELECT purchases, country, name, genre_id, 
    ROW_NUMBER() OVER(PARTITION BY country ORDER BY purchases DESC) AS RowNo 
    FROM (
        SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id
        FROM invoice_line 
        JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
        JOIN customer ON customer.customer_id = invoice.customer_id
        JOIN track ON track.track_id = invoice_line.track_id
        JOIN genre ON genre.genre_id = track.genre_id
        GROUP BY customer.country, genre.name, genre.genre_id
    ) AS subquery
)
SELECT * 
FROM popular_genre 
WHERE RowNo = 1;

















