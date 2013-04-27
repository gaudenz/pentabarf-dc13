CREATE OR REPLACE VIEW debconf.view_dc_conference_person AS
SELECT  view_conference_person.conference_person_id, 
        view_conference_person.person_id, 
        view_conference_person.conference_id, 
        view_conference_person.name, 
        view_conference_person.abstract, 
        view_conference_person.description, 
        view_conference_person.remark, 
        view_conference_person.email, 
        view_conference_person.arrived, 
        view_conference_person.reconfirmed, 
        dc_conference_person.accom_id, 
        dc_conference_person.daytrip_id, 
        dc_conference_person.computer_id, 
        dc_conference_person.assassins, 
        dc_conference_person.public_data, 
        dc_conference_person.wireless, 
        dc_conference_person.badge, 
        dc_conference_person.foodtickets, 
        dc_conference_person.nsh,
        dc_conference_person.paid, 
        dc_conference_person.paid_number, 
        dc_conference_person.cancelled,
        dc_conference_person.bag, 
        dc_conference_person.shirt, 
        dc_conference_person.hostel, 
        dc_conference_person.proceeded, 
        dc_conference_person.paiddaytrip, 
        dc_conference_person.googled,
        dc_conference_person.drunken, 
        dc_conference_person.gotdaytrip, 
        dc_conference_person.proceedings, 
        dc_conference_person.t_shirt_sizes_id, 
        dc_conference_person.food_id
   FROM debconf.dc_conference_person
   JOIN view_conference_person ON (debconf.dc_conference_person.person_id = view_conference_person.person_id AND
                                   debconf.dc_conference_person.conference_id = view_conference_person.conference_id);