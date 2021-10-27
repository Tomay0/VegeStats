class AddMessageFunction < ActiveRecord::Migration[6.1]
  def change
    ActiveRecord::Base.connection.execute <<-SQL
      CREATE OR REPLACE FUNCTION add_message(c_id text, c_name text, g_id text, g_name text, u_id text, u_name text, msg_id text, msg text, msg_timestamp text)
      RETURNS VOID
      LANGUAGE PLPGSQL
      AS
      $$
      DECLARE
      g_name2 TEXT;
      c_name2 TEXT;
      u_name2 TEXT;
      c_ts TIMESTAMP;
      BEGIN
      SELECT CURRENT_TIMESTAMP INTO c_ts;
      SELECT guild_name INTO g_name2 FROM guilds WHERE id = CAST(g_id AS BIGINT);
      IF NOT FOUND THEN
          INSERT INTO guilds VALUES (CAST(g_id AS BIGINT), g_name, c_ts, c_ts);
      ELSIF g_name <> g_name2 THEN
          UPDATE guilds SET guild_name = g_name WHERE id = CAST(g_id AS BIGINT);
          UPDATE guilds SET updated_at = c_ts WHERE id = CAST(g_id AS BIGINT);
      END IF;
      SELECT channel_name INTO c_name2 FROM channels WHERE id = CAST(c_id AS BIGINT);
      IF NOT FOUND THEN
          INSERT INTO channels VALUES (CAST(c_id AS BIGINT), CAST(g_id AS BIGINT), c_name, c_ts, c_ts);
      ELSIF c_name <> c_name2 THEN
          UPDATE channels SET channel_name = c_name WHERE id = CAST(c_id AS BIGINT);
          UPDATE channels SET updated_at = c_ts WHERE id = CAST(c_id AS BIGINT);
      END IF;
      SELECT user_name INTO u_name2 FROM users WHERE id = CAST(u_id AS BIGINT);
      IF NOT FOUND THEN
          INSERT INTO users VALUES (CAST(u_id AS BIGINT), u_name, c_ts, c_ts);
      ELSIF u_name <> u_name2 THEN
          UPDATE users SET user_name = u_name WHERE id = CAST(u_id AS BIGINT);
          UPDATE users SET updated_at = c_ts WHERE id = CAST(u_id AS BIGINT);
      END IF;
      IF EXISTS (SELECT * FROM messages WHERE id = CAST (msg_id AS BIGINT)) THEN
          UPDATE messages SET id = CAST(g_id AS BIGINT), channel_id = CAST(c_id AS BIGINT), user_id = CAST(u_id AS BIGINT), message = msg, message_timestamp = TO_TIMESTAMP(msg_timestamp, 'YYYY-MM-DD HH24:MI:SS'), updated_at = c_ts WHERE id = CAST (msg_id AS BIGINT);
      ELSE
          INSERT INTO messages VALUES (CAST(msg_id AS BIGINT), CAST(g_id AS BIGINT), CAST(c_id AS BIGINT), CAST(u_id AS BIGINT), msg, TO_TIMESTAMP(msg_timestamp, 'YYYY-MM-DD HH24:MI:SS'), c_ts, c_ts);
      
      END IF;
      
      END;
      $$;
    SQL
  end
end
