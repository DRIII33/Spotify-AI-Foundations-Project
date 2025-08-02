-- EDA Query 1: High-Level User Behavior Metrics
-- This query provides a snapshot of our core engagement metrics for the entire user base.
-- We're looking at total streams, average duration, and the percentage of skipped songs.
-- This gives us a baseline to measure the impact of our new AI feature against.
SELECT
    count(distinct user_id) AS total_users,
    count(*) AS total_streams,
    -- Calculate the average listening time per stream.
    avg(stream_duration_sec) AS avg_stream_duration_sec,
    -- Calculate the percentage of streams that were skipped.
    avg(skipped_flag) * 100 AS skipped_rate_percentage
FROM
    `spotify_ai_foundations.user_behavior`;


-- EDA Query 2: AI Commentary Event Distribution
-- This query helps us understand how the new GenShuffle feature is being used.
-- We're counting the number of times AI commentary started and the type of user feedback received.
-- This is a critical metric for understanding the feature's adoption and initial reception.
SELECT
    event_type,
    count(*) AS event_count
FROM
    `spotify_ai_foundations.gen_shuffle_events`
GROUP BY
    event_type
ORDER BY
    event_count DESC;


-- EDA Query 3: Linking User Behavior to AI Commentary
-- This query performs a join to see which users received AI commentary and how their behavior compares.
-- We're linking user streams to the presence of an AI commentary event.
-- Note: A more advanced analysis would use a window function to match commentary to the next song played. This simplified version provides a directional signal.
SELECT
    t1.user_id,
    -- Calculate the average duration for users who received commentary.
    avg(t1.stream_duration_sec) AS avg_duration_with_commentary,
    -- Calculate the skip rate for those users.
    avg(t1.skipped_flag) * 100 AS skip_rate_with_commentary
FROM
    `spotify_ai_foundations.user_behavior` AS t1
JOIN
    (SELECT distinct user_id FROM `spotify_ai_foundations.gen_shuffle_events` WHERE event_type = 'commentary_start') AS t2
    ON t1.user_id = t2.user_id
GROUP BY
    t1.user_id
LIMIT 10;
