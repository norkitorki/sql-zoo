-- Table schema:

CREATE TABLE stops (id INTEGER PRIMARY KEY, name TEXT);

CREATE TABLE route (num INTEGER PRIMARY KEY, company TEXT, pos INTEGER, stop INTEGER FOREIGN KEY);

/* 1. How many stops are in the database. */

SELECT COUNT(*)
FROM stops;

/* 2. Find the id value for the stop 'Craiglockhart'. */

SELECT id 
FROM stops
WHERE name = 'Craiglockhart';

/* 3. Give the id and the name for the stops on the '4' 'LRT' service. */

SELECT id, name
FROM stops
JOIN route ON route.stop = stops.id
WHERE company = 'LRT' AND num = 4;

/* 4. Add a HAVING clause to restrict the output to these two routes. */

SELECT company, num, COUNT(*)
FROM route WHERE stop = 149 OR stop = 53
GROUP BY company, num
HAVING COUNT(*) > 1;

/* 5. Change the query so that it shows the services from Craiglockhart to London Road. */

SELECT a.company, a.num, a.stop, b.stop
FROM route a 
JOIN route b ON a.company = b.company AND a.num = b.num
WHERE a.stop = 53 AND b.stop = 149;

/* 6. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. */

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a 
JOIN route b ON a.company = b.company AND a.num = b.num
JOIN stops stopa ON a.stop = stopa.id
JOIN stops stopb ON b.stop = stopb.id
WHERE stopa.name = 'Craiglockhart' AND stopb.name = 'London Road';

/* 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith'). */

SELECT a.company, a.num
FROM route a
JOIN route b ON b.num = a.num AND b.company = a.company
WHERE a.stop = 115 AND b.stop = 137
GROUP BY company, num;

/* 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross' */

SELECT a.company, a.num
FROM route a
JOIN route b ON b.num = a.num AND b.company = a.company
JOIN stops stopa ON stopa.id = a.stop
JOIN stops stopb ON stopb.id = b.stop
WHERE stopa.name = 'Craiglockhart' AND stopb.name = 'Tollcross';

/* 9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, 
      including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services. */

SELECT stopb.name, a.company, a.num
FROM route a
JOIN route b ON b.num = a.num AND b.company = a.company
JOIN stops stopa ON stopa.id = a.stop
JOIN stops stopb ON stopb.id = b.stop
WHERE a.company = 'LRT' AND stopa.name = 'Craiglockhart';

/* 10. Find the routes involving two buses that can go from Craiglockhart to Lochend.
       Show the bus no. and company for the first bus, the name of the stop for the transfer,
       and the bus no. and company for the second bus. */

SELECT a.num, a.company, stop.name, b.num, b.company
FROM stops stop
JOIN route a ON a.stop = (SELECT id FROM stops WHERE name = 'Craiglockhart')
JOIN route b ON b.stop = (SELECT id FROM stops WHERE name = 'Lochend')
WHERE stop.id IN (SELECT stop FROM route WHERE num = a.num AND company = a.company) 
  AND stop.id IN (SELECT stop FROM route WHERE num = b.num AND company = b.company);
