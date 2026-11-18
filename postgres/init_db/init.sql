-- Runs once, when the kafka-postgres volume is first created.
CREATE TABLE IF NOT EXISTS public.customers (
    id         BIGSERIAL    PRIMARY KEY,
    first_name VARCHAR(50)  NOT NULL,
    last_name  VARCHAR(50)  NOT NULL,
    email      VARCHAR(150) NOT NULL UNIQUE,
    gender     VARCHAR(20)  NOT NULL
);

-- Debezium needs full row images so updates/deletes carry every column.
ALTER TABLE public.customers REPLICA IDENTITY FULL;
