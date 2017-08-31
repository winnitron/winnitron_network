class KeyMap < ActiveRecord::Base
  KEYS = (
    [
      "Numpad0",
      "Numpad1",
      "Numpad2",
      "Numpad3",
      "Numpad4",
      "Numpad5",
      "Numpad6",
      "Numpad7",
      "Numpad8",
      "Numpad9",
      "NumpadDot",

      "NumpadDiv",
      "NumpadMult",
      "NumpadAdd",
      "NumpadSub",
      "NumpadEnter",

      "Control",
      "Shift",
      "Alt",

      "Delete",
      "Insert",
      "Home",
      "End",
      "PgUp",
      "PgDn",

      "Up",
      "Down",
      "Left",
      "Right",

      "Space",
      "Tab",
      "Backspace",
    ] +
    ("a".."z").to_a +
    ("0".."9").to_a +
    "-=[]\\;',./`".chars +
    (1..12).map { |i| "F#{i}" }
  ).freeze

  CONTROLS = [
    "UP",
    "DOWN",
    "LEFT",
    "RIGHT",
    "BUTTON1",
    "BUTTON2"
  ].freeze

  enum template: [:default, :custom, :legacy, :flash, :pico8]

  belongs_to :game

  def bindings
    custom? ? custom_map : KEY_MAP_TEMPLATES[template].slice(*(1..game.max_players).map(&:to_s))
  end
end
