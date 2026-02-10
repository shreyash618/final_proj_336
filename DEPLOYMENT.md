# Deploy Tech Barn on Railway

This guide walks you through deploying your Tech Barn auction app entirely on **Railway**: MySQL database and Tomcat web app (from GitHub).

---

## Prerequisites

- GitHub account with this repo pushed
- [Railway](https://railway.app) account

---

## Step 1: Create MySQL on Railway

1. Go to [Railway Dashboard](https://railway.app/dashboard) → **New Project**
2. Click **Add Service** → **Database** → **MySQL**
3. Railway provisions MySQL and creates a default database named `railway`
4. In the MySQL service → **Variables** tab, note:
   - `MYSQLHOST`
   - `MYSQLPORT`
   - `MYSQLUSER`
   - `MYSQLPASSWORD`
   - `MYSQLDATABASE` (default: `railway`)

---

## Step 2: Load Your Schema and Data

1. Connect to Railway MySQL (use **Connect** / TCP Proxy or a MySQL client)
2. Use the `railway` database (or create `tech_barn` if you prefer)
3. Run your schema:
   ```bash
   mysql -h <MYSQLHOST> -P <MYSQLPORT> -u <MYSQLUSER> -p railway < sql/updated_schema_seed.sql
   ```
   Or paste the contents of `sql/updated_schema_seed.sql` into MySQL Workbench, DBeaver, or Railway's query UI.

---

## Step 3: Deploy the Web App on Railway

1. In the same Railway project → **Add Service** → **GitHub Repo**
2. Select your `final_proj_336` repository
3. Railway detects the **Dockerfile** and builds the Tomcat app
4. **Add Variable References** to connect to MySQL:
   - Go to your web service → **Variables** → **Add Variable Reference**
   - Select the MySQL service
   - Add references for: `MYSQLHOST`, `MYSQLPORT`, `MYSQLUSER`, `MYSQLPASSWORD`, `MYSQLDATABASE`
   - If your DB is `railway`, `MYSQLDATABASE` will already be correct
5. **Generate domain**: Web service → **Settings** → **Networking** → **Generate Domain**

Your app will be at `https://<your-service>.up.railway.app`.

---

## Step 4: Verify

- Open the generated URL
- Log in with a user from your seed data
- Confirm database connectivity works

---

## Troubleshooting

| Issue | What to try |
|-------|-------------|
| 503 / app won't start | Check **Logs**; often a DB connection problem. Confirm variable references are set. |
| DB connection refused | Ensure both MySQL and web service are in the same Railway project. |
| Access denied | Double-check `MYSQLUSER` and `MYSQLPASSWORD` from the MySQL Variables tab. |
| Tables missing | Run `sql/updated_schema_seed.sql` against the `railway` database. |
| Questions not saving | Run `sql/alter_question_columns.sql` to widen title/contents columns. |

---

## Local Development

Locally, the app uses defaults in `ApplicationDB.java`:

- Host: `localhost`
- Database: `tech_barn`
- User: `root`
- Password: `password123`

For local DB name `railway`, set `MYSQLDATABASE=railway` in your environment or `launch.json`.

---

## Quick Reference

- **Database name**: `railway` (Railway default)
- **Env vars**: `MYSQLHOST`, `MYSQLPORT`, `MYSQLUSER`, `MYSQLPASSWORD`, `MYSQLDATABASE`
- **Schema**: `sql/updated_schema_seed.sql`
- **App URL**: `https://<service>.up.railway.app`
