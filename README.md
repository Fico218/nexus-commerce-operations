# Nexus Commerce Operations

A portfolio-ready full-stack workspace that combines PIM, DAM and lightweight ERP operations. The application is written in English for technical recruiters and demonstrates product data management, digital asset handling, inventory, orders, authentication and financial metrics.

## Modules

- **Overview:** live operating KPIs, low-stock alerts and recent orders.
- **Product Information Management:** create and manage SKUs, product data, prices and publishing status.
- **Digital Asset Management:** upload product files to Supabase Storage and approve assets.
- **Inventory:** record receipts, sales and adjustments; stock is calculated from immutable movements.
- **Orders:** track customer orders and their operational status.

## Stack

React 19, Vite, Supabase Auth, PostgreSQL, Row Level Security and Supabase Storage.

## Setup

1. Create a new Supabase project.
2. Run `supabase/schema.sql` in the Supabase SQL Editor.
3. In **Authentication > Providers**, enable Email. Users can register from the Nexus login screen using **New here? Create an account**. For a faster portfolio demo, disable **Confirm email** in the Email provider settings; otherwise the user must confirm the email before signing in.
4. Copy `.env.example` to `.env` and set the project URL plus its publishable/anon key from **Project Settings > API**.
5. Install and run:

```bash
npm install
npm run dev
```

The browser client uses the public Supabase key only. Do not put a `service_role` key in this application.

## Deployment

Deploy to Vercel, Netlify or Railway as a static Vite application. Add `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` as build-time environment variables. Use `npm run build` for the build command and `dist` as the output folder.
