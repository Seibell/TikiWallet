# Server

## Setup
Running the server:
```
npm i
npx prisma generate
npm run app
```

### PostgreSQL Google CloudSQL
To connect to database with CLI terminal:

```
psql "sslmode=disable dbname=<DBNAME> user=postgres host=<HOSTADDRESS>"
```
prompted with password

Ensure .env file is properly configured:
```
DATABASE_URL="postgresql://<USER>:<PASSWORD>@<HOSTADDR>:5432/<DBNAME>?schema=public"
```

### Prisma ORM
Guide for syntax:
https://www.prisma.io/docs/concepts/components/prisma-client

- example code in controller/authController.js: under testCreateUser function

To update schema:
1. update table using CLI
    - update table using CLI with appropriate psql commands
    - do `npx prisma db pull` to auto-update prisma/schema.prisma file
    - `npx prisma generate`

2. update schema.prisma file
    - update in .prisma file
    - do `npx prisma db push` to update tables in db
    - warning pop up just ignore and type `y`
    - if any error pop up, probably due to constraints
    - `npx prisma generate`