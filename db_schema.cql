DROP KEYSPACE IF EXISTS	 smartpot;

CREATE KEYSPACE smartpot WITH REPLICATION = {
   			'class' : 'SimpleStrategy',
			'replication_factor' : 1
  				};

USE smartpot;

--CREATE TABLE mqtt_acl (
--		allow_		tinyint,
--		ipaddr		text,
--		username 	uuid,
--  		clientid 	text,
--  		access 		tinyint,
--  		topic 		text,
--  		primary key (username)
--		);
--INSERT INTO mqtt_acl (allow_, ipaddr, username, clientid, access, topic)
--VALUES
--	(1,NULL, ade6f058-40ae-4fd6-b650-c4e5ced3e6bd,NULL,2,'ade6f058-40ae-4fd6-b650-c4e5ced3e6bd/#');

--INSERT INTO mqtt_acl (allow_, ipaddr, username, clientid, access, topic)
--VALUES
--	(0,NULL,'$all',NULL,1,'$SYS/#');
--INSERT INTO mqtt_acl (allow_, ipaddr, username, clientid, access, topic)
--VALUES
--	(0,NULL,'$all',NULL,1,'eq #');

--INSERT INTO mqtt_acl (id, allow_, ipaddr, username, clientid, access, topic)
--VALUES
--	(uuid(),1,'127.0.0.1',NULL,NULL,2,'$SYS/#');
--INSERT INTO mqtt_acl (id, allow_, ipaddr, username, clientid, access, topic)
--VALUES
--	(uuid(),1,'127.0.0.1',NULL,NULL,2,'#');
--INSERT INTO mqtt_acl (id, allow_, ipaddr, username, clientid, access, topic)
--VALUES
--	(uuid(),1,NULL,'dashboard',NULL,1,'$SYS/#');


CREATE TABLE user (
		id 					  uuid,
		username			text,
    roles         text,
    password      text,
    salt          text,
		email 				text,
		access_token 	text,
		access_token_created 	timestamp,
		zipcode 			text,
		when_registered 	date,
		owned_device_ids	set<uuid>,
		PRIMARY KEY (email)
		);




-- TODO: track the logins--IP, last_login etc.

CREATE TABLE mqtt_auth(
		id 					     uuid primary key,
		password 			   text,
		salt 				     text,
		is_superuser 		 tinyint,
		);



CREATE TABLE thing (
		id 				      uuid primary key,
		plant_type 			  text,
		plant_name 			  text,
		water_frequency    	int,
		water_amount		  int,
		when_added			  timestamp,
		last_watered	      timestamp,

		--pictures			list,
		);

-- basicaaly, sensor tables keep MQTT msgs
CREATE TABLE thing_msgs(
		device_id	  uuid,
		msg_id		  text,
		qos			    tinyint,
		topic		    text,
		payload		  text,
		ts			timeuuid,
		flags		text,
		headers		text,
		week		text,
		PRIMARY KEY((device_id, week), ts)
		) WITH CLUSTERING ORDER BY (ts DESC)
			AND COMPACTION = {'class': 'TimeWindowCompactionStrategy',
			'compaction_window_unit': 'DAYS',
			'compaction_window_size': 7};
