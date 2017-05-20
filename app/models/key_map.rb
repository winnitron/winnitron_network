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

      "LControl",
      "RControl",
      "LShift",
      "RShift",
      "LAlt",
      "RAlt",

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

  CONTROLS = (1..4).flat_map do |p|
    [
      "UP",
      "DOWN",
      "LEFT",
      "RIGHT",
      "BUTTON1",
      "BUTTON2"
    ].map { |c| "P#{p}_#{c}"}
  end.freeze

  enum template: [:default, :custom, :legacy, :flash, :pico8]

  belongs_to :game

  def bindings
    custom? ? custom_map : KEY_MAP_TEMPLATES[template]
  end

  def set(control, new_key)
    raise ArgumentError, "Cannot set custom key on non-custom template" if !custom?
    raise ArgumentError, "Invalid control: #{control}" if !CONTROLS.include?(control)
    raise ArgumentError, "Invalid key: #{new_key}" if !KEYS.include?(new_key)

    self.custom_map ||= {}
    custom_map[control.downcase.to_sym] = new_key
  end
end
