/* This tutorial introduces JOIN which allows you to use data from two or more tables. */

-- Table schema:

CREATE TABLE game (id INTEGER PRIMARY KEY, mdate TEXT, stadium TEXT, team1 TEXT, team2 TEXT);

CREATE TABLE goal (matchid INTEGER FOREIGN KEY, teamid INTEGER FOREIGN KEY, player TEXT, gtime INTEGER);

CREATE TABLE eteam (id TEXT PRIMARY KEY, teamname TEXT, coach TEXT);

/* 1. Create a query to show the matchid and player name for all goals scored by Germany. */

SELECT matchid, player 
FROM goal 
WHERE teamid = 'GER';

/* 2. Show id, stadium, team1, team2 for just game 1012. */

SELECT id,stadium,team1,team2
FROM game
WHERE id = 1012;

/* 3. Modify the query to show the player, teamid, stadium and mdate for every German goal. */

SELECT player, teamid, stadium, mdate
FROM game 
JOIN goal ON id = matchid
WHERE teamid = 'GER';

/* 4. Show the team1, team2 and player for every goal scored by a player called Mario. */

SELECT team1, team2, player
FROM game 
JOIN goal ON id = matchid
WHERE player LIKE 'Mario%';

/* 5. Show player, teamid, coach, gtime for all goals scored in the first 10 minutes. */

SELECT player, teamid, coach, gtime
FROM goal
JOIN eteam ON teamid = id
WHERE gtime <= 10;

/* 6. List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach. */

SELECT mdate, teamname
FROM game
JOIN eteam ON team1 = eteam.id
WHERE coach = 'Fernando Santos';

/* 7. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw' */

SELECT player
FROM goal 
JOIN game ON matchid = id
WHERE stadium = 'National Stadium, Warsaw';

/* 8. Show the name of all players who scored a goal against Germany. */

SELECT DISTINCT player
FROM goal
JOIN game ON matchid = id AND (team1 = 'GER' OR team2 = 'GER')
WHERE teamid != 'GER';

/* 9. Show teamname and the total number of goals scored. */

SELECT teamname, COUNT(teamid)
FROM eteam
JOIN goal ON id = teamid
GROUP BY teamname;

/* 10. Show the stadium and the number of goals scored in each stadium. */

SELECT stadium, COUNT(matchid)
FROM game
JOIN goal ON id = matchid
GROUP BY stadium;

/* 11. For every match involving 'POL', show the matchid, date and the number of goals scored. */

SELECT matchid, mdate, COUNT(gtime)
FROM goal
JOIN game ON matchid = id
WHERE team1 = 'POL' OR team2 = 'POL'
GROUP BY matchid, mdate;

/* 12. For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'. */

SELECT matchid, mdate, COUNT(gtime)
FROM goal
JOIN game ON matchid = id
WHERE teamid = 'GER'
GROUP BY matchid, mdate;

/* 13. List every match with the goals scored by each team. */

SELECT mdate,
team1,
(SELECT COUNT(teamid) FROM goal WHERE team1 = teamid AND id = matchid) AS score1,
team2,
(SELECT COUNT(teamid) FROM goal WHERE team2 = teamid AND id = matchid) AS score2
FROM game
ORDER BY mdate, id, team1, team2;