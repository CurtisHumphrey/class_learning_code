Templates =
  HOME: 'home_page'
  SETTINGS: 'settings_page'



class Square_VM
  constructor: (marker = @BLANK_MARKER) ->
    @marker = ko.observable marker
    
  ## Class Constants
  HUMAN_MARKER: 'X'
  CPU_MARKER: 'O'
  BLANK_MARKER: ''

class Main_Controller_VM
  constructor: (inits) ->
    @board_squares = ko.observableArray []
    
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
    
    @_Create_Board()
    
  ## Helper Functions
  _Create_Board: =>
    underlying_board = @board_squares()
    underlying_board.push new Square_VM() for n in [1..(3*3)]
    underlying_board[1].marker Square_VM::HUMAN_MARKER
    underlying_board[3].marker Square_VM::CPU_MARKER
    @board_squares.valueHasMutated()
   
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