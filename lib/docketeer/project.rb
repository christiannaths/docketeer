module Docketeer
  class Project

    # Create a new project
    def initialize(client, project, options)
      # Instantiate config object
      config = Docketeer::Config.new

      # Set Default options if none were given
      options.default(:path => config.project_dir)

      # Instantiate logger object
      logger = Docketeer::Logger.new(config.log_path)

      # Generate a new, unique docket number
      # using the Logger class
      docket = logger.next

      # Set the project path and create the folders
      project_path = File.join(File.expand_path(options.path), client, "#{ docket } #{ project }")
      FileUtils.mkdir_p(project_path)

      # Add a log entry using the Logger class
      logger.add([docket, client, project, project_path, Time.now.to_s].join(", "))

      puts "Initializing #{ project_path }"
      puts "Logging to #{ logger.path }"

    end

  end
end
