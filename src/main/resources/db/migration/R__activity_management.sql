CREATE OR REPLACE FUNCTION add_activity(in_title varchar(200) ,in_description text ,in_owner_id bigint DEFAULT null)  RETURNS "activity" AS $$
	DECLARE
		ajout "activity"%rowtype;
		new_id bigint := nextval('id_generator');
	BEGIN 
		IF in_owner_id is null THEN
			INSERT INTO activity 
			VALUES (new_id, in_title, in_description,now(),now(), (select id from get_default_owner()));
        ELSE 
        	INSERT INTO activity 
			VALUES (new_id, in_title, in_description,now(),now(), in_owner_id);
		END IF;
		SELECT * INTO ajout FROM "activity"
        WHERE id = new_id;
		RETURN ajout;
	END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION find_all_activities(activities_cursor refcursor) RETURNS refcursor AS $$
	DECLARE
		b "user"%rowtype;
	BEGIN 
		
   		OPEN $1 FOR SELECT A.id, A.title, U.username 
   		            FROM activity A 
   		            FULL OUTER JOIN "user" U 
   		            ON A.owner_id = U.id;  
		return $1;
		
		
		
	END
$$ LANGUAGE plpgsql;