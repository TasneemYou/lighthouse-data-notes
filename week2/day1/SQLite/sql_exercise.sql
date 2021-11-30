/* SQL Exercise
====================================================================
We will be working with database imdb.db
You can download it here: https://drive.google.com/file/d/1E3KQDdGJs4a0i1RoYb8DEq0PFxCgI6cN/view?usp=sharing
*/


-- MAKE YOURSELF FAMILIAR WITH THE DATABASE AND TABLES HERE


select * from movies;
select * from aka_names;
select * from aka_titles;
select * from movie_distributors;
select * from cinematographers;
select * from distributors;

--==================================================================
/* TASK I
 Find the id's of movies that have been distributed by “Universal Pictures”.
*/
select m.movie_id from movies m join movie_distributors md on 
md.movie_id = m.movie_id join distributors d on d.distributor_id = md.distributor_id
where d.name = 'Universal Pictures';

/* TASK II
 Find the name of the companies that distributed movies released in 2006.
*/
select d.name from movies m join movie_distributors md on 
md.movie_id = m.movie_id join distributors d on d.distributor_id = md.distributor_id
where m.year = 2006;

/* TASK III
Find all pairs of movie titles released in the same year, after 2010.
hint: use self join on table movies.
*/

select m1.title, ak1.title from aka_titles ak1 join movies m1 on ak1.movie_id = m1.movie_id
join movies m2 on ak1.movie_id = m2.movie_id
where m1.year > 2010 and m1.year = m2.year;

/* TASK IV
 Find the names and movie titles of directors that also acted in their movies.
*/
select p.name, m.title from movies m join roles r on m.movie_id = r.movie_id
join people p on p.person_id=r.person_id where p.person_id in (select person_id from directors);

/* TASK V
Find ALL movies realeased in 2011 and their aka titles.
hint: left join
*/
select m.title, ak.title from movies m left join aka_titles ak on m.movie_id = ak.movie_id
where m.year =2011; 



/* TASK VI
Find ALL movies realeased in 1976 OR 1977 and their composer's name.
*/
select m.title, p.name from movies m join composers c on c.movie_id=m.movie_id
join people p on p.person_id = c.person_id
where year in (1976,1977);



/* TASK VII
Find the most popular movie genres.
*/
select g.label, count(g.label) from genres g join movie_genres mg on g.genre_id = mg.genre_id
join movies m on m.movie_id = mg.movie_id where m.rating >8.8
group by g.label order by count(g.label) desc;
/* TASK VIII
Find the people that achieved the 10 highest average ratings for the movies 
they cinematographed.
*/

select p.name, avg(m.rating) as avg_rating from people p join cinematographers c on c.person_id=p.person_id
join movies m on m.movie_id = c.movie_id group by c.person_id order by avg_rating desc limit 10 ;

/* TASK IX
Find all countries which have produced at least one movie with a rating higher than
8.5.
hint: subquery
*/
select distinct c.name from countries c join movie_countries mc on c.country_id = mc.country_id
where mc.movie_id in (select movie_id from movies WHERE
rating > 8.5);



/* TASK X
Find the highest-rated movie, and report its title, year, rating, and country. There
can be ties; if so, you should report for each of them.
*/
select m.title, m.year, m.rating, c.name from movies m join movie_countries mc
on mc.movie_id = m.movie_id join countries c on c.country_id=mc.country_id 
where m.rating = (select max(rating) from movies);

/* STRETCH BONUS
Find the pairs of people that have directed at least 5 movies and whose 
carees do not overlap (i.e. The release year of a director's last movie is 
lower than the release year of another director's first movie).
*/
