-- 3. Supply-Demand Mismatch

/* Objective: To identify periods when the number of requests 
exceeds the number of completed trips, 
indicating potential supply shortages.
Questions: Supply vs. Demand: Are there periods when the number of 
trip requests exceeds the number of trips completed? 
What are the times or dates when supply might not meet demand?*/

-- Requests vs. Completed Trips
SELECT
    DATE_TRUNC('day', "Request timestamp") AS period,
    COUNT(*) AS total_requests,
    COUNT(CASE WHEN "Status" = 'Trip Completed' THEN 1 END) AS completed_trips,
    ROUND((COUNT(CASE WHEN "Status" = 'Trip Completed' THEN 1 END) * 100.0 / COUNT(*)), 2) 
	AS completion_rate_percentage
FROM
    uber_request_data
GROUP BY
    DATE_TRUNC('day', "Request timestamp")
ORDER BY
    period;


--  Identifying the High-Demand Periods 
WITH request_summary AS (
    SELECT
        CASE
            WHEN EXTRACT(HOUR FROM "Request timestamp") BETWEEN 0 AND 11 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM "Request timestamp") BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS time_phase,
        COUNT(*) AS total_requests,
        COUNT(CASE WHEN "Status" = 'Trip Completed' THEN 1 END) AS completed_trips
    FROM
        uber_request_data
    GROUP BY
        time_phase
)
SELECT
    time_phase,
    total_requests,
    completed_trips,
    total_requests - completed_trips AS uncompleted_requests,
    ROUND((total_requests - completed_trips) * 100.0 / total_requests, 2) AS uncompleted_requests_percentage
FROM
    request_summary
WHERE
    total_requests > completed_trips
ORDER BY
    uncompleted_requests DESC;


-- Time-Based Analysis of Car Availability
WITH availability_summary AS (
    SELECT
        CASE
            WHEN EXTRACT(HOUR FROM "Request timestamp") BETWEEN 0 AND 11 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM "Request timestamp") BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS time_phase,
        COUNT(*) AS total_requests,
        COUNT(CASE WHEN "Status" = 'No Cars Available' THEN 1 END) AS no_cars_available_trips
    FROM
        uber_request_data
    GROUP BY
        time_phase
)
SELECT
    time_phase,
    total_requests,
    no_cars_available_trips,
    ROUND((no_cars_available_trips * 100.0 / total_requests), 2) AS no_cars_available_rate
FROM
    availability_summary
ORDER BY
    no_cars_available_rate DESC;



-- Identifying Peak Hours for Cancelled Trips
SELECT 
    CASE
        WHEN EXTRACT(HOUR FROM "Request timestamp") BETWEEN 0 AND 11 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM "Request timestamp") BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_phase,
    COUNT(*) AS cancelled_trips
	
FROM 
    uber_request_data
WHERE 
    "Status" = 'Cancelled'
GROUP BY 
    time_phase
ORDER BY 
    cancelled_trips DESC;



-- Driver Availability During Peak Cancellation Hours
SELECT 
    EXTRACT(DAY FROM "Request timestamp") AS days,
    COUNT(DISTINCT "Driver id") AS available_drivers,
    SUM(CASE WHEN "Status" = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_trips
FROM 
    uber_request_data
GROUP BY 
    days
ORDER BY 
    cancelled_trips DESC;


-- Investigating Customer Behavior
SELECT 
    EXTRACT(DAY FROM "Request timestamp") AS days,
    "Pickup point",
    COUNT(*) AS total_requests,
    SUM(CASE WHEN "Status" = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_trips,
    ROUND(SUM(CASE WHEN "Status" = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS cancellation_rate
FROM 
    uber_request_data
GROUP BY 
    days, "Pickup point"
ORDER BY 
    cancellation_rate DESC;
































