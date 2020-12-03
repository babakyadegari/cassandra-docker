--DROP KEYSPACE IF EXISTS	smartpot;

CREATE KEYSPACE IF NOT EXISTS smartpot WITH REPLICATION = {
   			'class' : 'SimpleStrategy',
			'replication_factor' : 1
  				};

CREATE TABLE IF NOT EXISTS smartpot.user (
		id            text,
		username			text,
    roles         text,
    password      text,
    salt          text,
		email 				text,
		access_token 	text,
		access_token_created 	timestamp,
		zipcode 			text,
		when_registered 	timestamp,
		owned_device_ids	set<uuid>,
		PRIMARY KEY (email, id)
		);


-- TODO: track the logins--IP, last_login etc.

CREATE TABLE IF NOT EXISTS smartpot.mqtt_auth(
		id 					     text primary key,
		password 			   text,
		salt 				     text,
		is_superuser 		 tinyint,
		);


CREATE TABLE IF NOT EXISTS smartpot.thing (
		id 				        text primary key,
    user_id           text,
		plant_type 			  text,
		plant_name 			  text,
		water_frequency   int,
		water_amount		  int,
    soil_moisture_level int,
		when_added			  timestamp,
		last_watered      timestamp,

		--pictures			list,
		);

-- basically, sensor tables keep MQTT msgs
CREATE TABLE IF NOT EXISTS smartpot.thing_msgs(
		device_id	  text,
		msg_id		  text,
		topic		    text,
		payload		  text,
		ts          timestamp,
		week        text,
		PRIMARY KEY((device_id, week), ts)
		) WITH CLUSTERING ORDER BY (ts DESC)
			AND COMPACTION = {'class': 'TimeWindowCompactionStrategy',
			'compaction_window_unit': 'DAYS',
			'compaction_window_size': 7};


CREATE TABLE IF NOT EXISTS smartpot.thing_actions(
		device_id	  text,
		ts          timestamp,
		week        text,
    action      tinyint,
    reason      text,
		PRIMARY KEY((device_id, week), ts)
		) WITH CLUSTERING ORDER BY (ts DESC)
			AND COMPACTION = {'class': 'TimeWindowCompactionStrategy',
			'compaction_window_unit': 'DAYS',
			'compaction_window_size': 7};


CREATE TABLE IF NOT EXISTS smartpot.msg_to_things_queue(
    device_id    text primary key,
    ts          timestamp,
    topic       text,
    msg         text,
    queued      tinyint,
);


--CREATE TABLE mqtt_acl (
--		allow_		tinyint,
--		ipaddr		text,
--		username 	uuid,
--  		clientid 	text,
--  		access 		tinyint,
--  		topic 		text,
--  		primary key (username)
--		);
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
