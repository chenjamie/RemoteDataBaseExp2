# RemoteDatabaseApiApp

This is a tabbed-view iOS application that uses a custom Flask api to store registered user data (name, birthday, salary, number of logins, last updated timestamp) with login via email and passoword through a remote PostgreSQL database on the same network. Admin accounts will be able see a list of all user and edit their data at will, which includes making other users admins and vice-versa.

# Development/testing setup in Xcode, setup PostgreSQL database

Step 1: Choose the RemoteDatabaseExp2 to clone 

Step 2: Install Python, Flask, SQLAlchemy, requests, datetime, and json libraries on the remote device

Step 3: Set up the PostgreSQL database on the remote device with the following table: 
    
    CREATE TABLE public.users(
        email character varying(30) COLLATE pg_catalog."default" NOT NULL,
        password character varying(50) COLLATE pg_catalog."default" NOT NULL,
        name character varying(30) COLLATE pg_catalog."default" NOT NULL,
        birthday date,
        salary real,
        is_admin boolean NOT NULL,
        login_num integer NOT NULL,
        "timestamp" timestamp without time zone NOT NULL,
        CONSTRAINT users_pkey PRIMARY KEY (email)
    )

    
Step 4: Configure your database to accept remote connections https://bosnadev.com/2015/12/15/allow-remote-connections-postgresql-database-server/

Step 5: Put file api.py in a desired folder on the remote device 

Step 6: Replace value of HOST_IP in Util.swift and api.py with the ip of the network you are on

Step 7: Replace value of HOST_PORT in Util.swift with the port that api.py will run on (usually 5000)

Step 8 Change fields to string "postgresql://username:password@hostname/database_name" in api.py to fit your individual database setup

Step 9: Run the Flask application on your remote device with command "python api.py"

Step 10: Run the Xcode project on a simulator or plugged in iOS device

Step 11: Make sure the remote device and whatever device that is running the iOS application is on the same network

# Demo
 
Register New User Example: 

https://drive.google.com/file/d/1dXDKswn-zExs99bSzWuuemPApT5QwPZT/view?usp=sharing

Login Success:

https://drive.google.com/file/d/1PmhjsfyGyWc-0_w2mlN_QfeD0hceADI7/view?usp=sharing

Login Failure:

https://drive.google.com/file/d/1MkUVrYVnSsXBV0eGSW_NU9FR-qAP4eSv/view?usp=sharing

Admin screen example:

https://drive.google.com/file/d/1daXFsiGy9H04UJ6tU6ttNFWILuPyWNEQ/view?usp=sharing

User screen example:

https://drive.google.com/file/d/1JbrcRI_Xlzl7VUsSXzuC0RuEYodNAfqv/view?usp=sharing

Editting User info Screen example: 

https://drive.google.com/file/d/1CpEySGzOA9nLd0ZgGUW_9Jxdo46ZuQch/view?usp=sharing

# Dependencies

Python, Python requests, datetime, and json libraries, Flask, SQLAlchemy, PostgreSQL, psycopg2-binary
