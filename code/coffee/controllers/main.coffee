Templates =
  HOME: 'home_page'
  SETTINGS: 'settings_page'

class Main_Controller_VM
  constructor: (inits) ->
    @template_name = ko.observable Templates.SETTINGS
    @display_page = => 
      return @template_name()
    
    @title = ko.observable "Home Testing"
    
    @player_name = ko.observable ""
    @need_help = ko.observable false
    @first_player = ko.observable ""
    
    @difficulty_level = ko.observable "Easy"
    @difficulty_options = ko.observableArray ['Easy', 'Semi-Easy', 'Medium', 'Hard', 'Crazy']
    
    @settings = ko.computed =>
      unless @player_name()
        "Need to pick a name"
      else
        """
        #{@player_name()}
        is going #{if @first_player() is 'me' then 'first' else 'second'},
        #{if @need_help() then 'wants' else 'does not want'} help,
        and is playing at #{@difficulty_level()} difficulty.
        """
 
 
  ##Event Bindings
  Tap_Home: (d, e) =>
    @template_name Templates.HOME
  Tap_Settings: (d, e) =>
    @template_name Templates.SETTINGS
  ##Other Bindings
  Refresh_JQM: (d) =>
    $(d).trigger("create")
    #v = $(d).find("ul")
    #v.listview 'refresh'
    return
  
$(document).one 'app_init', (e, d) ->
  console.log "Loading Main VM"
  model = new Main_Controller_VM()
  ko.applyBindings model
  return