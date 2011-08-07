module Docketeer
  class Config
    attr_accessor :project_dir
    attr_accessor :log_path
    attr_accessor :config_path

    PROJECT_DIR = File.expand_path("~/Projects/")
    LOG_PATH = File.expand_path("~/Projects/.projects.log")

    def initialize
      @config_path = File.join(File.dirname(__FILE__), 'config.yml')
      unless File.exists?(@config_path) && YAML.load_file(@config_path)
        File.open(@config_path, 'a+') do |file|
          file.puts "project_dir: #{ PROJECT_DIR }"
          file.puts "log_path: #{ LOG_PATH }"
        end
      end
      config = YAML.load_file(@config_path)
      @log_path = File.expand_path(config['log_path']) || PROJECT_DIR
      @project_dir = File.expand_path(config['project_dir']) || LOG_PATH
    end

    def show
      config = YAML.load_file(self.config_path)
      config.each do |key, value|
        puts [key, value].join(": ")
      end
    end

    def set_project_dir(path)
      if File.file?(path)
        puts "Error: #{ path } is the name of an existing file. Please name a new or existing directory to use as your default project folder."
        return false
      else
        puts "project_dir: #{ File.expand_path path }"
        update_config_file('project_dir', path)
      end
    end

    def set_log_path(path)
      if File.directory?(path)
        puts "Error: #{ path } is a directory. Please name a new or existing file to use as the log file."
        return false
      else
        puts "log_path: #{ File.expand_path path }"
        update_config_file('log_path', path)

      end
    end


    private

    def update_config_file(key_to_update, value)
      config = YAML.load_file(self.config_path)
      new_value = File.expand_path(value)
      old_value = File.expand_path(config[key_to_update])
      if new_value == old_value
        return false
      else
        config[key_to_update] = new_value

        File.open(self.config_path, 'w') do |file|
          config.each do |key, value|
            file.puts([key, value].join(': '))
          end
        end

        return true
      end
    end

  end
end
