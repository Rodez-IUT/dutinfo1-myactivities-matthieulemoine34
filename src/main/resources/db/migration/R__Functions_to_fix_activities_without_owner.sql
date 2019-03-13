
CREATE OR REPLACE FUNCTION get_default_owner() RETURNS "user" AS $$
	DECLARE
		defaultOwner "user"%rowtype;
	BEGIN
		SELECT * INTO defaultOwner
		FROM "user"
		WHERE username = 'Default Owner';
		IF NOT FOUND THEN
			INSERT INTO "user"
			VALUES (nextval('id_generator'),'Default Owner');
			SELECT * INTO defaultOwner FROM "user" WHERE username = 'Default Owner';					
		END IF;
		RETURN defaultOwner;
	END;
$$ LANGUAGE PLpgsql;

CREATE OR REPLACE FUNCTION fix_activities_without_owner() RETURNS SETOF activity AS $$
	
	BEGIN
		SELECT *
		FROM activity
		WHERE username = 'Default Owner';
		IF NOT FOUND THEN
	
	
	END;
	
$$ LANGUAGE PLpgsql;