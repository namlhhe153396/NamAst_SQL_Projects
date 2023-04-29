use  ig_clone ;
/* #12 Mega Challenges
# Are we overrun with bots and celebrity accounts?
# Find the percentage of our users who have either never commented on a photo or have commented on every photo*/
SELECT tableA.total_A AS 'Number Of Users who never commented',
		(tableA.total_A/(SELECT COUNT(*) FROM users))*100 AS '%',
		tableB.total_B AS 'Number of Users who likes every photos',
		(tableB.total_B/(SELECT COUNT(*) FROM users))*100 AS '%'
FROM
(
		SELECT COUNT(*) AS total_A FROM
			(SELECT username,comment_text
				FROM users
				LEFT JOIN comments ON users.id = comments.user_id
				GROUP BY users.id
				HAVING comment_text IS NULL) AS total_number_of_users_without_comments
	) AS tableA
JOIN
(	SELECT COUNT(*) AS total_B
	FROM
		(	SELECT TABLEC.id , COUNT(TABLEC.photo_id) AS total
			FROM (	SELECT DISTINCT users.id,comments.photo_id 
					FROM users
					LEFT JOIN comments ON comments.user_id = users.id  
				) AS TABLEC
			GROUP BY TABLEC.id
			HAVING total = (SELECT COUNT(*) FROM photos  )
				
		) AS users_comments_every_photos
)AS TABLEB

/*#13 Find users who have ever commented on a photo */

/*#14 Are we overrun with bots and celebrity accounts? 
# Find the percentage of our users who have either never commented on a photo or have commented on photos before*/

