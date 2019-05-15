CREATE OR REPLACE FUNCTION register_user_on_activity(id_user bigint, id_activity bigint) RETURNS "registration" AS $$
	DECLARE
		ligne "registration"%rowtype;

	BEGIN
			select * into ligne from "registration"
   		         where user_id = id_user
     	  	     and activity_id = id_activity;
     	   	if not found then
				INSERT INTO registration (id,user_id,activity_id)
		    	values (nextval('id_generator'),id_user,id_activity);
		    	select * into ligne from "registration"
   		            where user_id = id_user
     	  	        and activity_id = id_activity;
			else 
				RAISE EXCEPTION 'registration_already_exists';
			end if;
			return ligne;
	
	END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION unregister_user_on_activity(id_user bigint, id_activity bigint) RETURNS void AS $$
	DECLARE
		lignes "registration"%rowtype;
	
	BEGIN
			select *into lignes from "registration"
   		         where user_id = id_user
     	  	     and activity_id = id_activity;
     	   	if not found then
     	   		RAISE EXCEPTION 'registration_not_found';
			else 
				DELETE FROM "registration" 
				WHERE user_id = id_user
				and activity_id = id_activity;
			end if;
	END
$$ LANGUAGE plpgsql;


    

DROP TRIGGER IF EXISTS log_delete_registration on registration ;

-- fonction trigger
CREATE OR REPLACE FUNCTION log_delete_registration()
    RETURNS TRIGGER AS $$
BEGIN
     INSERT INTO action_log (id, action_name, entity_name, entity_id, author, action_date)
        values  (nextval('id_generator'),'delete', 'registration', OLD.id, user, now());
     RETURN NULL; -- le résultat est ignoré car il s'agit d'un trigger AFTER
END;
$$ language plpgsql;

-- trigger
CREATE TRIGGER log_delete_registration
    AFTER DELETE ON registration
    FOR EACH ROW EXECUTE PROCEDURE log_delete_registration();




DROP TRIGGER IF EXISTS log_insert_registration on registration ;

-- fonction trigger
CREATE OR REPLACE FUNCTION log_insert_registration()
    RETURNS TRIGGER AS $$
BEGIN
     INSERT INTO action_log (id, action_name, entity_name, entity_id, author, action_date)
        values  (nextval('id_generator'),'insert', 'registration', NEW.id, user, now());
     RETURN NULL; -- le résultat est ignoré car il s'agit d'un trigger AFTER
END;
$$ language plpgsql;


CREATE TRIGGER log_insert_registration
    AFTER insert ON registration
    FOR EACH ROW EXECUTE PROCEDURE log_insert_registration();