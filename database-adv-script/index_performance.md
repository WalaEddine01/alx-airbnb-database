
# Index Performance Analysis

## Before Indexes

### Query 1: User Lookup
```sql
EXPLAIN ANALYZE SELECT * FROM User WHERE email = 'example@email.com';
```
[Insert EXPLAIN ANALYZE output]

## After Indexes

### Query 1: User Lookup
```sql
EXPLAIN ANALYZE SELECT * FROM User WHERE email = 'example@email.com';
```
[Insert EXPLAIN ANALYZE output]

## Analysis
- [List improvements observed]
- [Note any areas needing further optimization]

![Database Schema Diagram](/home/wala/alx-airbnb-database/database-adv-script/download.png)