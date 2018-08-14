CREATE SCHEMA IF NOT EXISTS public;
CREATE SCHEMA IF NOT EXISTS private;

CREATE EXTENSION pgcrypto;

GRANT USAGE ON SCHEMA public TO public;
GRANT USAGE ON SCHEMA private TO public;
CREATE TYPE private.jwt_token AS (
    role text,
    exp integer,
    user_id uuid,
    is_admin boolean,
    username text
);

-- Create users table with required privileges
CREATE TABLE IF NOT EXISTS users (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    fullname text,
    username text NOT NULL UNIQUE,
    email text NOT NULL UNIQUE,
    password text NOT NULL,
    is_admin bool NOT NULL DEFAULT FALSE
);

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
GRANT SELECT (id, fullname, username, email) ON users TO public;
GRANT UPDATE (fullname) ON users TO public;

DROP POLICY IF EXISTS users_role ON users;
CREATE POLICY users_role ON users FOR ALL
    USING (current_user = username)
    WITH CHECK (current_user = username);

-- Create authentication functions
CREATE OR REPLACE FUNCTION public.authenticate(email text, password text) RETURNS private.jwt_token AS $$
DECLARE
    account public.users;
BEGIN
    SELECT a.* INTO account
        FROM public.users AS a
        WHERE a.email = authenticate.email;

    IF account.is_admin THEN
        RETURN NULL;
    END IF;

    IF account.password = crypt(password, account.password) THEN
        RETURN (
            account.username,
            extract(epoch FROM now() + interval '30 days'),
            account.id,
            account.is_admin,
            account.username
        )::private.jwt_token;
    ELSE
        RETURN NULL;
    END IF;
END;
$$ LANGUAGE plpgsql STRICT SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.signup(username text, email text, password text, fullname text, is_admin boolean = FALSE) RETURNS SETOF uuid AS $$
BEGIN
    IF (SELECT TRUE FROM pg_roles WHERE rolname = signup.username) THEN
        RAISE EXCEPTION 'Duplicate user';
    END IF;

    EXECUTE 'CREATE ROLE ' || quote_ident( signup.username );

	RETURN QUERY INSERT INTO users AS u (fullname, username, email, is_admin, password)
		VALUES (
			signup.fullname, signup.username, signup.email, signup.is_admin,
			crypt(signup.password, gen_salt('md5'))
		)
		RETURNING id;
END;
$$ LANGUAGE plpgsql STRICT SECURITY INVOKER;


-- Create admin role
SELECT signup('admin', 'admin@domain.tld', '78f065b26b184b379d4b3d3f3ff5096f', 'Administrator', true);
GRANT ALL ON SCHEMA public TO admin;
GRANT ALL ON SCHEMA private TO admin;
ALTER DEFAULT PRIVILEGES FOR USER admin
    REVOKE EXECUTE ON FUNCTIONS FROM public;

-- Create non-authenticated role
CREATE ROLE nouser;
REVOKE ALL ON SCHEMA public FROM nouser;
REVOKE ALL ON SCHEMA private FROM nouser;
REVOKE EXECUTE ON FUNCTION public.signup(username text, email text, password text, fullname text, is_admin boolean) FROM public;
GRANT EXECUTE ON FUNCTION public.authenticate(email text, password text) TO nouser;
GRANT USAGE ON SCHEMA public TO nouser;