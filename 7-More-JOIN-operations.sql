/* This tutorial introduces the notion of a join. */

-- Table schema:

CREATE TABLE movie (id INTEGER PRIMARY KEY, title TEXT, yr INTEGER, director INTEGER FOREIGN KEY, budget INTEGER, gross INTEGER);

CREATE TABLE actor (id PRIMARY KEY, name TEXT);

CREATE TABLE casting (movieid INTEGER PRIMARY KEY FOREIGN KEY, actorid INTEGER PRIMARY KEY FOREIGN KEY, ord INTEGER);

/* 1. Example exercise. - skip */

/* 2. Give year of 'Citizen Kane'. */

SELECT yr
FROM movie
WHERE title = 'Citizen Kane';

/* 3. List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). 
      Order results by year. */

SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr;

/* 4. What id number does the actor 'Glenn Close' have? */

SELECT id 
FROM actor
WHERE name = 'Glenn Close';

/* 5. What is the id of the film 'Casablanca'? */

SELECT id
FROM movie
WHERE title = 'Casablanca';

/* 6. Obtain the cast list for 'Casablanca'. */

SELECT name
FROM actor
JOIN casting ON id = actorid
WHERE movieid = (SELECT id FROM movie WHERE title = 'Casablanca');

/* 7. Obtain the cast list for the film 'Alien'. */

SELECT name
FROM actor
JOIN casting ON id = actorid
WHERE movieid = (SELECT id FROM movie WHERE title = 'Alien');

/* 8. List the films in which 'Harrison Ford' has appeared. */

SELECT title
FROM movie
JOIN casting ON id = movieid
WHERE actorid = (SELECT id FROM actor WHERE name = 'Harrison Ford');

/* 9. List the films where 'Harrison Ford' has appeared - but not in the starring role. */

SELECT title 
FROM movie
JOIN casting ON id = movieid
WHERE actorid = (SELECT id FROM actor WHERE name = 'Harrison Ford') AND ord != 1;

/* 10. List the films together with the leading star for all 1962 films. */

SELECT title, name
FROM movie m
JOIN casting c ON m.id = c.movieid
JOIN actor a ON c.actorid = a.id
WHERE yr = 1962 AND ord = 1;

/* 11. Which were the busiest years for 'Rock Hudson', 
       show the year and the number of movies he made each year for any year in which he made more than 2 movies. */

SELECT yr, COUNT(title) AS movieCount
FROM movie 
JOIN casting ON movie.id = movieid
JOIN actor ON actorid = actor.id
WHERE name = 'Rock Hudson'
GROUP BY yr
HAVING movieCount > 2;

/* 12. List the film title and the leading actor for all of the films 'Julie Andrews' played in. */

SELECT title, name
FROM casting
JOIN movie ON movieid = movie.id
JOIN actor ON actorid = actor.id
WHERE ord = 1 AND movieid IN (SELECT movieid FROM casting WHERE actorid IN (SELECT id from actor WHERE name = 'Julie Andrews'));

/* 13. Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles. */

SELECT name
FROM actor
JOIN casting ON id = actorid AND ord = 1
GROUP BY name
HAVING COUNT(actorid) > 14
ORDER BY name;

/* 14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title. */

SELECT title, COUNT(actorid)
FROM movie
JOIN casting ON movie.id = movieid
JOIN actor ON actorid = actor.id
WHERE yr = 1978
GROUP BY title
ORDER BY COUNT(actorid) DESC, title;

/* 15. List all the people who have worked with 'Art Garfunkel'. */

SELECT DISTINCT name
FROM actor
JOIN casting ON id = actorid
WHERE movieid IN (SELECT movieid FROM casting WHERE actorid IN (SELECT id FROM actor WHERE name = 'Art Garfunkel'));

