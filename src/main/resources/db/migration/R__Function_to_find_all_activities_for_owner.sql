CREATE OR REPLACE FUNCTION find_all_activities_for_owner(name varchar(500)) RETURNS SETOF activity AS $$
	select A.*
    from activity A
    join "user" U
    on   owner_id = U.id
    where U.username = name;
$$ LANGUAGE SQL;