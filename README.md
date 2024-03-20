# Alumni Portal Server

This is the server side of the Alumni Portal application.

## Setting up the environment

- Clone the repository

```bash
git clone git@github.com:tripathics/alumni-portal-server.git
```

- Install the dependencies

```bash
cd alumni-portal-server   # Move to the server directory
npm install               # Install the dependencies
```

- Create a `.env` file in the root of the project and add the environment variables from the `.env.example` file. Put the actual values in the `.env` file.

```bash
cp .env.example .env
```

- Migration and seeding: Run the following command to create the database tables and seed the database with the admin user.

```bash
npm run migrate
```

- Start the server

```bash
npm run dev
```
