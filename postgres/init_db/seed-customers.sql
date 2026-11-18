-- Insert mock customers into public.customers (first_name, last_name, email, gender).
-- Usage:  docker exec -i kafka-postgres psql -U postgres -d kafka_db -v n=1000 < postgres/seed-customers.sql
-- Emails use example.com, a reserved domain, so they never belong to a real person.

\if :{?n}
\else
  \set n 1000
\endif

WITH
male_names AS (SELECT ARRAY[
  'Sokha','Dara','Rithy','Vichea','Kosal','Rathana','Piseth','Sovann','Visal','Kimheng',
  'Makara','Panha','Sothea','Davith','Sophal','Vuthy','Bunthoeun','Narith','Ratanak','Seyha',
  'Veasna','Vireak','Bunna','Chamroeun','Puthea'
] AS a),
female_names AS (SELECT ARRAY[
  'Chenda','Bopha','Pisey','Sreymom','Nary','Sokunthea','Malis','Leakhena','Sreyneang','Channary',
  'Raksmey','Mony','Lina','Sreypov','Kolab','Phalla','Sokny','Dalin','Kanha','Monika',
  'Sopheap','Vanna','Chantha','Theara','Chanthy'
] AS a),
last_names AS (SELECT ARRAY[
  'Sok','Chan','Kim','Heng','Ly','Seng','Meas','Chea','Keo','Nhem',
  'Phan','Sam','Vong','Prak','Touch','Long','Ouk','Pen','Mao','Yim',
  'Chhay','Lim','Tep','Sum','Hor','Chhun','Kong','Nget','Pich','Ros'
] AS a),
genders AS (
  SELECT g,
         CASE WHEN random() < 0.5 THEN 'Male' ELSE 'Female' END AS gender
  FROM generate_series(1, :n) AS g
),
picked AS (
  SELECT g.g,
         g.gender,
         CASE WHEN g.gender = 'Male'
              THEN m.a[1 + floor(random() * array_length(m.a, 1))::int]
              ELSE f.a[1 + floor(random() * array_length(f.a, 1))::int]
         END AS first_name,
         l.a[1 + floor(random() * array_length(l.a, 1))::int] AS last_name
  FROM genders g, male_names m, female_names f, last_names l
)
INSERT INTO public.customers (first_name, last_name, email, gender)
SELECT first_name,
       last_name,
       lower(first_name) || '.' || lower(last_name) || '.'
         || substr(md5(random()::text || g), 1, 6) || '@example.com',
       gender
FROM picked
ON CONFLICT (email) DO NOTHING;
