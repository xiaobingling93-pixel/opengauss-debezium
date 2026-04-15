-- Sequence test script
-- Test scenarios: Basic sequence, cached sequence, cyclic sequence, sequence with max value

-- 1. Basic sequence
CREATE SEQUENCE basic_sequence
START WITH 1
INCREMENT BY 1;

-- 2. Cached sequence
CREATE SEQUENCE cached_sequence
START WITH 1
INCREMENT BY 1
CACHE 100;

-- 3. Cyclic sequence
CREATE SEQUENCE cyclic_sequence
START WITH 1
INCREMENT BY 1
MAXVALUE 100
CYCLE;

-- 4. Sequence with max value
CREATE SEQUENCE max_value_sequence
START WITH 1
INCREMENT BY 5
MAXVALUE 1000;

-- View created sequences
SELECT sequence_name, min_value, max_value, increment_by, cycle_flag, cache_size 
FROM user_sequences;
