
-- returns all accepted events with no conference track set
CREATE OR REPLACE FUNCTION conflict.conflict_event_no_track(INTEGER) RETURNS SETOF conflict.conflict_event AS $$
      SELECT event_id
        FROM event
       WHERE conference_id = $1 AND
             event_state = 'accepted' AND
             conference_track IS NULL
$$ LANGUAGE SQL;

