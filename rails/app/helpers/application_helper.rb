# Methods added to this helper will be available to all templates in the application.

require 'builder_helper'
require 'localizer'

module ApplicationHelper
  include Builder_helper

  def pentabarf_version
    "0.3.7"
  end

  # tries to read the current revision of pentabarf from subversion meta data
  def pentabarf_revision
    if not self.class.class_variables.member?( '@@revision' )
      revision_file = File.join( RAILS_ROOT, '..', '.svn', 'entries' )
      begin
        content = File.open( revision_file, 'r').read
        if content[0..1] == '<?'    # new svn xml file
          d = REXML::Document.new( content )
          rev = d.elements['//entry[@name=""]/@revision'].to_s
        else                        # simple txt file
          rev = content.split("\n")[3]
        end
        rev = rev.to_i
      rescue
        rev = 0
      end
      @@revision = rev
    end
    @@revision.to_s
  end

  def local( tag )
    Localizer.lookup( tag.to_s, @current_language )
  end

  def js( text )
    text.to_s.gsub(/[<>]/, '').gsub( '\\', '\0\0' ).gsub(/\r\n|\n|\r/, "\\n").gsub(/["']/, '\\\\\0')
  end

  def js_function( name, *parameter )
    parameter.map! do | p |
      if p == true then "true"
      elsif p == false then "false"
      elsif p == nil then "null"
      else "'#{js(p.to_s)}'" end
    end
    "#{name}(#{parameter.join(',')});"
  end

  def js_tabs( tabs )
    xml = Builder::XmlMarkup.new
    xml.div( :id => 'tabs' ) do
      tabs.each do | tab |
        xml.span( tab.to_s, {:id=>"tab-#{tab}",:onclick=>"switch_tab('#{tab}')",:class=>'tab inactive'} )
      end
      xml.span( 'Show all', {:id=>"tab-all",:onclick=>"show_all_tabs()",:class=>'tab inactive'} )
    end
  end

  def schedule_table( conference, events )
    table = []
    timeslot_seconds = conference.timeslot_duration.hour * 3600 + conference.timeslot_duration.min * 60
    slots_per_day = ( 24 * 60 * 60 ) / timeslot_seconds
    start = (conference.day_change.hour * 3600) + (conference.day_change.min * 60) + conference.day_change.sec
    # create an array for each day
    conference.days.times do | i | table[i] = [] end
    # fill array with times
    table.each_with_index do | day_table, day |
      current = 0
      while current < 24 * 60 * 60
        table[day].push( { 0 => sprintf("%02d:%02d", ((current + start)/3600)%24, ((current + start)%3600)/60 ) } )
        current += timeslot_seconds
      end
    end
    events.each do | event |
      slots = (event.duration.hour * 3600 + event.duration.min * 60)/timeslot_seconds
      start_slot = (event.start_time.hour * 3600 + event.start_time.min * 60) / timeslot_seconds
      next if table[event.day - 1][start_slot][event.conference_room]
      table[event.day - 1][start_slot][event.conference_room] = {:event_id => event.event_id, :slots => slots}
      slots.times do | i |
        next if i < 1
        # check whether the event spans multiple days
        if (start_slot + i) >= slots_per_day
          if (start_slot + i)%slots_per_day == 0
            table[event.day - 1 + (start_slot + i)/slots_per_day][(start_slot + i)%slots_per_day][event.conference_room] = {:event_id => event.event_id, :slots => slots - i}
          else
            table[event.day - 1 + (start_slot + i)/slots_per_day][(start_slot + i)%slots_per_day][event.conference_room] = 0
          end
        else
          table[event.day - 1][start_slot + i][event.conference_room] = 0
        end
      end
    end
    table.each do | day_table |
      while day_table.first && day_table.first.length == 1
        day_table.delete(day_table.first)
      end
      while day_table.last && day_table.last.length == 1
        day_table.delete(day_table.last)
      end
    end
    table
  end

  def markup( text )
    BlueCloth.new( text.to_s, :filter_html ).to_html
   rescue
    "BlueCloth error"
  end

  def paginate( xml, results, active_page )
    results_per_page = 42
    show_first, show_last, show_around = 3, 3, 4
    pages = (results.length / results_per_page.to_f).ceil
    active_page = pages - 1 if active_page >= pages
    xml.div do
      xml.span "#{results.length} results found."
      xml.br
      pages.times do | page |
        xml.text! "..." if page == show_first && active_page >= ( show_first + show_around )
        xml.text! "..." if page == ( pages - show_last ) && active_page < ( pages - ( show_last + show_around ) )
        next if page >= show_first && page < ( pages - show_last ) && ( page <= ( active_page - show_around) || page >= ( active_page + show_around ) )
        xml.button("#{page+1}",{:type=>:button,:class=>"paginate #{page==active_page ? :active : nil}",:onclick=>"new Ajax.Updater('results','#{url_for(:id=>page)}');"})
      end if results.length > results_per_page
    end
    yield( results[(active_page * results_per_page)..((active_page+1) * results_per_page - 1 )] || [] )
    xml.div do
      pages.times do | page |
        xml.text! "..." if page == show_first && active_page >= ( show_first + show_around )
        xml.text! "..." if page == ( pages - show_last ) && active_page < ( pages - ( show_last + show_around ) )
        next if page >= show_first && page < ( pages - show_last ) && ( page <= ( active_page - show_around) || page >= ( active_page + show_around ) )
        xml.button("#{page+1}",{:type=>:button,:class=>"paginate #{page==active_page ? :active : nil}",:onclick=>"new Ajax.Updater('results','#{url_for(:id=>page)}');"})
      end if results.length > results_per_page
    end
  end

end
