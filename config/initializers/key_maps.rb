file = File.read(File.expand_path('../../key_map_templates.yml', __FILE__))
KEY_MAP_TEMPLATES = YAML.load(file).with_indifferent_access
