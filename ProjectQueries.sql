--------------------------------------------------------------------------------------------------

SELECT CATEGORY,
	SUBGROUP,
	COUNT(SUBGROUP) AS NO_OF_TIMES
FROM PUBLIC.EVENTS
GROUP BY CATEGORY,
	SUBGROUP;

---------------------------------------------------------------------------------------------------

SELECT E.SUBGROUP,
	E.EVENT_TYPE,CAS.AFFECTED
FROM EVENTS E
INNER JOIN CASUALITIES CAS ON CAS.EVENT_ID = E.EVENT_ID
WHERE CAS.AFFECTED > 500
GROUP BY E.CATEGORY,
	E.SUBGROUP,
	E.EVENT_TYPE,
	CAS.AFFECTED;


---------------------------------------------------------------------------------------------------

SELECT L.LOCATIONS,
	COUNT(DISTINCT E.EVENT_ID) AS TOTAL_EVENTS,
	SUM(CASE
									WHEN R.FEDERAL_PAYMENTS IS NOT NULL THEN 1
									ELSE 0
					END) AS EVENTS_WITH_FEDERAL_PAYMENTS,
	SUM(CASE
									WHEN R.PROVINCIAL_PAYMENTS IS NOT NULL THEN 1
									ELSE 0
					END) AS EVENTS_WITH_PROVINCIAL_PAYMENTS
FROM LOCATIONS L
JOIN EVENTS E ON L.EVENT_ID = E.EVENT_ID
LEFT JOIN RELIEF_AID R ON E.EVENT_ID = R.RELIEF_AID_ID
GROUP BY L.LOCATIONS
HAVING COUNT(DISTINCT E.EVENT_ID) > 5
ORDER BY TOTAL_EVENTS DESC;

---------------------------------------------------------------------------------------------------------------------------------------------------------
*/
SELECT E.EVENT_GROUP,
	E.EVENT_TYPE,
	MAX(C.ESTIMATED_TOTAL_COST) AS MAX_COST,
	MIN(C.ESTIMATED_TOTAL_COST) AS MIN_COST,
	ROUND(AVG(CAST(C.ESTIMATED_TOTAL_COST AS numeric))) AS AVG_COST
FROM EVENTS E
JOIN CASUALITIES C ON E.EVENT_ID = C.EVENT_ID
GROUP BY E.EVENT_TYPE,
	E.EVENT_GROUP
HAVING COUNT(EVENT_TYPE) > 5
ORDER BY AVG_COST DESC;


--------------------------------------------------------------------------------------------------------------------

SELECT CONCAT(E.EVENT_TYPE,

								': ',
								L.LOCATIONS) AS EVENT_LOCATION,
	COUNT(E.EVENT_ID) AS EVENT_COUNT
FROM EVENTS E
JOIN LOCATIONS L ON E.EVENT_ID = L.EVENT_ID
GROUP BY EVENT_LOCATION
HAVING COUNT(E.EVENT_ID) >= 3
ORDER BY EVENT_COUNT DESC;


---------------------------------------------------------------------------------------------------------------------------------------------

SELECT
	E.EVENT_TYPE,
	C.FATALITIES,
	C.AFFECTED
FROM EVENTS E
JOIN CASUALITIES C ON E.EVENT_ID = C.EVENT_ID
WHERE C.FATALITIES >
		(SELECT AVG(FATALITIES)
			FROM CASUALITIES)
	AND C.AFFECTED >
		(SELECT AVG(AFFECTED)
			FROM CASUALITIES)
ORDER BY C.FATALITIES DESC,
	C.AFFECTED DESC;


------------------------------------------------------------------------------------------------------------------------------------------------
WITH FATALITIESCTE AS
	(SELECT EVENT_ID,
			FATALITIES,
			ROW_NUMBER() OVER (
ORDER BY FATALITIES DESC) AS RN
		FROM CASUALITIES)
SELECT 
	E.EVENT_TYPE,
	F.FATALITIES
FROM FATALITIESCTE F
JOIN EVENTS E ON F.EVENT_ID = E.EVENT_ID
WHERE F.RN <= 5
order by F.FATALITIES  DESC;


------------------------------------------------------------------------------------------------

SELECT E.CATEGORY,
	E.SUBGROUP,
	SUM(C.FATALITIES) AS TOTAL_FATALITIES,
	SUM(C.AFFECTED) AS TOTAL_AFFECTED,
	SUM(C.ESTIMATED_TOTAL_COST) AS TOTAL_ESTIMATED_COST
FROM EVENTS E
JOIN CASUALITIES C ON E.EVENT_ID = C.EVENT_ID
GROUP BY E.CATEGORY,
	E.SUBGROUP
ORDER BY TOTAL_FATALITIES DESC,
	TOTAL_AFFECTED DESC,
	TOTAL_ESTIMATED_COST DESC;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WITH EVENTSEVERITY AS
	(SELECT E.EVENT_TYPE,
			C.FATALITIES,
			CASE
							WHEN C.FATALITIES = 0 THEN 'No Fatalities'
							WHEN C.FATALITIES <= 10 THEN 'Low Fatalities'
							WHEN C.FATALITIES <= 50 THEN 'Medium Fatalities'
							ELSE 'High Fatalities'
			END AS SEVERITY_CATEGORY
		FROM EVENTS E
		JOIN CASUALITIES C ON E.EVENT_ID = C.EVENT_ID)
SELECT ES.EVENT_TYPE,
	ES.FATALITIES,
	ES.SEVERITY_CATEGORY
FROM EVENTSEVERITY ES
WHERE ES.SEVERITY_CATEGORY = 'High Fatalities'
	OR ES.SEVERITY_CATEGORY = 'Medium Fatalities'
ORDER BY ES.FATALITIES DESC;


------------------------------------------------------------------------------------------------------------------------------------------------
WITH EVENTCOSTSEVERITY AS
	(SELECT E.EVENT_ID,
			E.EVENT_TYPE,
			E.CATEGORY,
			E.EVENT_GROUP,
			C.NORMALIZED_TOTAL_COST,
			CASE
							WHEN C.NORMALIZED_TOTAL_COST < 1000000 THEN 'Low Cost'
							WHEN C.NORMALIZED_TOTAL_COST >= 1000000
												AND C.NORMALIZED_TOTAL_COST < 5000000 THEN 'Medium Cost'
							WHEN C.NORMALIZED_TOTAL_COST >= 5000000 THEN 'High Cost'
							ELSE 'Unknown'
			END AS COST_SEVERITY
		FROM PUBLIC.EVENTS E
		JOIN PUBLIC.CASUALITIES C ON E.EVENT_ID = C.EVENT_ID)
SELECT COST_SEVERITY,
	COUNT(*) AS EVENT_COUNT,
	SUM(NORMALIZED_TOTAL_COST) AS TOTAL_COST
FROM EVENTCOSTSEVERITY
GROUP BY COST_SEVERITY
ORDER BY TOTAL_COST DESC;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT E.EVENT_TYPE,
	COUNT(C.CASUALITIES_ID) AS TOTAL_CASUALTIES,
	ROUND(AVG(C.ESTIMATED_TOTAL_COST)) AS AVERAGE_COST_PER_EVENT
FROM PUBLIC.EVENTS E
JOIN PUBLIC.CASUALITIES C ON E.EVENT_ID = C.EVENT_ID
WHERE E.EVENT_GROUP = 'Natural'
GROUP BY E.EVENT_TYPE,
	E.EVENT_GROUP
ORDER BY TOTAL_CASUALTIES DESC,
	AVERAGE_COST_PER_EVENT DESC;