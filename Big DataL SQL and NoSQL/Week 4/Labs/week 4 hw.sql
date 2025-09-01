--1
select concat(c.first_name, ' ' ,c.last_name) as customer_name,
count(r.rental_id) as rental_count
from customer c
join rental r
on c.customer_id = r.customer_id
group by c.customer_id
order by rental_count desc;

--2
select f.title, 
count (r.rental_id) as rental_count
from rental r 
join inventory i 
on r.inventory_id = i.inventory_id
join customer c 
on r.customer_id = c.customer_id
join film f
on i.film_id = f.film_id
where concat(c.first_name, ' ' ,c.last_name) = 'Eleanor Hunt'
group by f.film_id
having count(r.rental_id) > 1;

--3

select cat.name as fave_movie,
count (r.rental_id) as rental_count
from rental r 
join inventory i 
on r.inventory_id = i.inventory_id
join customer c 
on r.customer_id = c.customer_id
join film f
on i.film_id = f.film_id
join film_category fc
on f.film_id = fc.film_id
join category cat
on fc.category_id = cat.category_id
where concat(c.first_name, ' ' ,c.last_name) = 'Eleanor Hunt'
group by cat.name
order by rental_count desc;

--4
DELIMITER //

create trigger remove_inactive_customer
after update on customer
for each row
begin
	if New.active = -1 then 
		delete from customer where customer_id = New.customer_id;
	end if ;
end;
//
DELIMITER;


