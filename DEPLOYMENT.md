# Deploy Tech Barn (Render Web App + Railway MySQL)

This guide walks you through deploying your Tech Barn auction app: **MySQL on Railway** (free) and **Tomcat web app on Render**.

---

## Prerequisites

- GitHub account with this repo pushed
- [Render](https://render.com) account (for the web app)
- [Railway](https://railway.app) account (free MySQL)

---

## Step 1: Create MySQL on Railway

1. Go to [Railway Dashboard](https://railway.app/dashboard) → **New Project**
2. Click **Deploy from GitHub** or **Add Service**
3. Choose **Database** → **MySQL**
4. Railway will provision MySQL and show connection variables:
   - `MYSQLHOST`
   - `MYSQLPORT`
   - `MYSQLUSER` (usually `root` by default)
   - `MYSQLPASSWORD`
   - `MYSQLDATABASE`

**Using root only (no extra user):** Railway MySQL typically gives you root. Using `root` for your app is fine for demos and portfolio projects. No need to create another user—just use the `MYSQLUSER` and `MYSQLPASSWORD` Railway gives you (they may show as `root` or a generated name).

5. Create your database:
   - Railway may create a default DB (e.g. `railway`). You need `tech_barn`.
   - In the MySQL service, open the **Variables** tab and add or note:
     - `MYSQLDATABASE` = `tech_barn` (if you can set it), or create the DB manually in Step 2.

---

## Step 2: Load Your Schema and Data

1. Use Railway’s **Connect** or **TCP Proxy** to get a public host and port (or use a MySQL client that supports Railway’s connection method).
2. Connect with the credentials from Step 1.
3. Create the database if needed:
   ```sql
   CREATE DATABASE IF NOT EXISTS tech_barn;
   USE tech_barn;
   ```
4. Run your SQL:
   ```bash
   mysql -h <MYSQLHOST> -P <MYSQLPORT> -u <MYSQLUSER> -p tech_barn < sql/updated_schema_seed.sql
   ```
   Or paste the contents of `sql/updated_schema_seed.sql` into MySQL Workbench, DBeaver, or another client.

---

## Step 3: Deploy the Web App on Render

1. In [Render Dashboard](https://dashboard.render.com) → **New** → **Web Service**
2. Connect GitHub and select the `final_proj_336` repo
3. Configure:
   - **Name**: `techbarn`
   - **Runtime**: **Docker**
   - **Region**: any (Render and Railway can be in different regions)
4. **Environment Variables** — copy from Railway and map to your app:

   | Render Variable | Value (from Railway) |
   |-----------------|----------------------|
   | `MYSQLHOST`     | Railway `MYSQLHOST`  |
   | `MYSQLPORT`     | Railway `MYSQLPORT`  |
   | `MYSQLUSER`     | Railway `MYSQLUSER` (usually `root`) |
   | `MYSQLPASSWORD` | Railway `MYSQLPASSWORD` (mark as **Secret**) |
   | `MYSQLDATABASE` | `tech_barn`          |

   Your app supports both Railway (`MYSQLHOST`, etc.) and generic (`MYSQL_HOST`, etc.) variable names.

5. Click **Create Web Service**

Render will build and deploy. Your app will be at `https://techbarn.onrender.com` (or the name you chose).

---

## Step 4: Connect Railway MySQL Externally (if needed)

If Render can’t reach Railway’s internal host (e.g. different clouds):

1. In Railway → MySQL service → **Settings** → **Networking**
2. Enable **Public Networking** or **TCP Proxy** so the DB is reachable from the internet
3. Use the public host and port in `MYSQLHOST` and `MYSQLPORT` in Render

---

## Troubleshooting

| Issue | What to try |
|-------|-------------|
| 503 / app won’t start | Check Render **Logs**; often a DB connection problem. Confirm env vars match Railway. |
| DB connection refused | Ensure Railway MySQL has public networking enabled if Render is on a different provider. |
| Access denied | Double-check `MYSQLUSER` and `MYSQLPASSWORD` from Railway’s Variables tab. |
| Root only | Using root is fine for this project; no need to create another user. |

---

## Local Development

Locally, the app still uses defaults in `ApplicationDB.java`:

- Host: `localhost`
- Database: `tech_barn`
- User: `root`
- Password: `password123`

---

## Quick Reference

- **Railway env vars**: `MYSQLHOST`, `MYSQLPORT`, `MYSQLUSER`, `MYSQLPASSWORD`, `MYSQLDATABASE`
- **App URL**: `https://<your-service>.onrender.com`
- **Schema**: `sql/updated_schema_seed.sql`
