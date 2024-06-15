-- Hotel Operations SQL code

-- Query #1
SELECT 
    id,
    COALESCE(location, 'Unknown') AS location,
    CASE
        WHEN total_rooms BETWEEN 1 AND 400 THEN total_rooms
        ELSE 100
    END AS total_rooms,
    CASE
        WHEN staff_count IS NOT NULL THEN staff_count
        ELSE COALESCE(total_rooms, 100) * 1.5
    END AS staff_count,
    CASE
        WHEN opening_date = '-' OR opening_date IS NULL OR opening_date = '' THEN '2023'
        WHEN opening_date BETWEEN '2000' AND '2023' THEN opening_date
        ELSE '2023'
    END AS opening_date,
    CASE
        WHEN target_guests IS NULL THEN 'Leisure'
        WHEN LOWER(target_guests) LIKE 'b%' THEN 'Business'
        ELSE target_guests 
    END AS target_guests
FROM 
    public.branch;

-- Query #2
SELECT 
    service_id, 
    branch_id, 
    ROUND(AVG(time_taken), 2) AS avg_time_taken, 
    MAX(time_taken) AS max_time_taken
FROM 
    request
GROUP BY 
    service_id, branch_id;


-- Query #3
SELECT
    s.description,
    b.id AS branch_id,
    b.location,
    r.id AS request_id,
    r.rating
FROM
    request r
JOIN
    service s ON r.service_id = s.id
JOIN
    branch b ON r.branch_id = b.id
WHERE
    b.location IN ('EMEA', 'LATAM')
    AND s.description IN ('Meal', 'Laundry');


-- Query #4
SELECT
    service_id,
    branch_id,
    ROUND(AVG(rating), 2) AS avg_rating
FROM
    request
GROUP BY
    service_id, branch_id
HAVING
    AVG(rating) < 4.5;