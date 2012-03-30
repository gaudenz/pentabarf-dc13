CREATE TABLE person_rating_backup_dc10 AS SELECT * FROM person_rating;

truncate person_rating;

CREATE OR REPLACE VIEW debconf.dc_view_report_expenses AS SELECT DISTINCT conference_person.person_id, view_person.name, conference_person.conference_id, conference_person_travel.travel_cost, conference_person_travel.travel_currency, conference_person_travel.accommodation_cost, conference_person_travel.accommodation_currency, conference_person_travel.fee, conference_person_travel.fee_currency, dc_view_person_rating.quality, dc_view_person_rating.quality_count, dc_view_person_rating.competence, dc_view_person_rating.competence_count, dc_view_person_rating.rating FROM conference_person_travel JOIN conference_person USING (conference_person_id) JOIN view_person USING (person_id) JOIN debconf.dc_view_person_rating USING (person_id) LEFT JOIN log.conference_person_travel c USING (conference_person_id) LEFT JOIN log.log_transaction t USING (log_transaction_id, person_id) WHERE (conference_person_travel.need_travel_cost = true AND conference_person_travel.travel_cost IS NOT NULL OR conference_person_travel.need_accommodation_cost = true AND conference_person_travel.accommodation_cost IS NOT NULL OR conference_person_travel.fee IS NOT NULL) AND c.log_operation = 'U'::bpchar AND t.log_timestamp < '2011-05-19 00:00:00'::timestamp without time zone AND c.need_travel_cost = true ORDER BY conference_person.person_id, conference_person.conference_id, view_person.name, conference_person_travel.travel_cost, conference_person_travel.travel_currency, conference_person_travel.accommodation_cost, conference_person_travel.accommodation_currency, conference_person_travel.fee, conference_person_travel.fee_currency, dc_view_person_rating.quality, dc_view_person_rating.quality_count, dc_view_person_rating.competence, dc_view_person_rating.competence_count, dc_view_person_rating.rating;

