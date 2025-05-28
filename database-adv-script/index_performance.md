
# Index Performance Analysis

## Before Indexes

### Query 1: User Lookup
```sql
EXPLAIN ANALYZE SELECT * FROM User WHERE email = 'example@email.com';
```


## After Indexes

### Query 1: User Lookup
```sql
EXPLAIN ANALYZE SELECT * FROM users WHERE first_name = 'John';
```
Seq Scan on users  (cost=0.00..10.62 rows=1 width=1554) (actual time=0.019..0.021 rows=1 loops=1)
   Filter: ((first_name)::text = 'John'::text)
   Rows Removed by Filter: 2
 Planning Time: 0.089 ms
 Execution Time: 0.041 ms

![Database Schema Diagram](/home/wala/alx-airbnb-database/database-adv-script/download.png)