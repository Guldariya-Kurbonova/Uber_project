-- 2. Driver Performance Analysis

/* Objective:To evaluate driver performance by understanding the efficiency 
and productivity of each driver.
Question: What is the average duration of trips for each driver? 
Are there significant differences in trip durations among drivers?
How many trips does each driver complete in a given time period? */


-- The average trip duration per driver
SELECT 
    "Driver id",
	Round(AVG(EXTRACT(EPOCH FROM ("Drop timestamp" - "Request timestamp")) / 60), 2) 
	AS average_trip_duration_minutes
FROM 
    uber_request_data
WHERE 
    "Status" = 'Trip Completed'
GROUP BY 
    "Driver id"
ORDER BY 
    average_trip_duration_minutes DESC;


-- Number of Trips per Driver
SELECT 
    "Driver id",
    COUNT(*) AS number_of_trips
FROM 
    uber_request_data
WHERE 
    "Status" = 'Trip Completed'
GROUP BY 
    "Driver id"
ORDER BY 
    number_of_trips DESC;




	
	
	
	
	
	
	
	
	
	
	