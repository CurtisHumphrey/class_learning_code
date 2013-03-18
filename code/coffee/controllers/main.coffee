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

class Machine_VM
  constructor: (inits) ->
    @on = ko.observable false
    @rotate_pos = ko.observable true
    @effect = ko.computed =>
      unless @on()
        animate =
          css:
            '-webkit-transform': 'rotate(0deg)'
          parameters:
            duration: '200ms'
      else
        animate =
          css:
            '-webkit-transform': if @rotate_pos() then 'rotate(5deg)' else 'rotate(-5deg)'
          parameters:
            duration: '300ms'
            timingfunction: 'ease-out'
            callback: =>
              @rotate_pos !@rotate_pos()
  

class Main_Controller_VM
  constructor: (inits) ->
    @template_name = ko.observable Templates.HOME
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
    
    #@_Create_Board()
    
    #Animation KO
    @washer = new Machine_VM()
    @dryer = new Machine_VM()
    
  ## Helper Functions
  _Create_Board: =>
    underlying_board = @board_squares()
    underlying_board.push new Square_VM() for n in [1..(3*3)]
    underlying_board[1].marker Square_VM::HUMAN_MARKER
    underlying_board[3].marker Square_VM::CPU_MARKER
    @board_squares.valueHasMutated()
   
  ##Event Bindings
  Tap_Washer: (d, e) =>
    @washer.on !@washer.on()
    
  Tap_Dryer: (d, e) =>
    @dryer.on !@dryer.on()
    
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