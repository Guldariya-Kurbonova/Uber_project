SELECT *
FROM uber_request_data;

-- 1. Demand Analysis
/* Objective:To analyze trip request patterns by time of day and 
pickup location to optimize driver allocation and improve service efficiency.
Question: During which hours and at which pickup points do trip requests peak, 
and how can this data inform strategic decisions on driver deployment? */ 

-- Peak Hours Analysis
SELECT 
    EXTRACT(HOUR FROM "Request timestamp") AS hour_of_day,
    COUNT(*) AS number_of_requests
FROM 
    uber_request_data
GROUP BY 
    EXTRACT(HOUR FROM "Request timestamp")
ORDER BY 
    hour_of_day;
	

-- Pickup Point Analysis
SELECT 
    "Pickup point",
    COUNT(*) AS number_of_requests
FROM 
    uber_request_data
GROUP BY 
    "Pickup point"
ORDER BY 
    number_of_requests DESC;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
