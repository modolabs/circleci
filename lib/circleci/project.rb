# frozen_string_literal: true
module CircleCi
  ##
  #
  # Class for interacting with Projects
  class Project
    attr_reader :vcs_type, :username, :name

    ##
    # Return all projects for your API key
    #
    # @return [CircleCi::Response] - Response object
    def self.all
      CircleCi.request('/projects').get
    end

    ##
    # Initialize project
    #
    # @param vcs_type [String] - Either :github or :bitbucket, the version control system used for this project.
    # @param username [String] - Name of version control user/organization
    # @param project_name [String] - Name of the project in the version control system
    def initialize(vcs_type, username, project_name)
      @vcs_type = vcs_type.to_s
      @username = username
      @name     = project_name
    end

    ##
    # Build the latest master push for this project
    #
    # @return         [CircleCi::Response] - Response object
    def build
      CircleCi.request(base_path).post
    end

    ##
    # Build the latest push for this branch of a specific project
    #
    # @param branch   [String] - Name of branch
    # @param body     [Hash] - Optional post body with build parameters
    #
    # @return         [CircleCi::Response] - Response object
    def build_branch(branch, params = {}, body = {})
      CircleCi.request("#{base_path}/tree/#{branch}", params).post(body) 
    end

    ##
    # Add a ssh key to a build
    #
    # @param build    [String] - Build number
    # @param key      [String] - The ssh private key
    # @param hostname [String] - The hostname identified by the key
    #
    # @return         [CircleCi::Response] - Response object
    def build_ssh_key(build, key, hostname)
      body = { hostname: hostname, private_key: key }
      CircleCi.request("#{base_path}/#{build}/ssh-users").post(body)
    end

    ##
    # Clear the build cache for a specific project
    #
    # @return         [CircleCi::Response] - Response object
    def clear_cache()
      CircleCi.request("#{base_path}/build-cache").delete
    end

    ##
    # Delete a checkout key for a project
    #
    # @param fingerprint  [String] - Fingerprint of a checkout key
    #
    # @return             [CircleCi::Response] - Response object
    def delete_checkout_key(fingerprint)
      CircleCi.request("#{base_path}/checkout-key/#{fingerprint}").delete
    end

    ##
    # Enable a project in CircleCI. Causes a CircleCI SSH key to be added to
    # the GitHub. Requires admin privilege to the repository.
    #
    # @return         [CircleCi::Response] - Response object
    def enable
      CircleCi.request("#{base_path}/enable").post
    end

    ##
    # Get the project envvars
    #
    # @return         [CircleCi::Response] - Response object
    def envvar
      CircleCi.request("#{base_path}/envvar").get
    end


    ##
    # Sets an envvar for a project
    #
    # @param envvar   [Hash] - {name: 'foo', value: 'bar'}
    #
    # @return         [CircleCi::Response] - Response object
    def set_envvar(envvar)
      CircleCi.request("#{base_path}/envvar").post(envvar)
    end

    ##
    # Follow the project
    #
    # @param username [String] - User or org name who owns project
    # @param project  [String] - Name of project
    #
    # @return         [CircleCi::Response] - Response object
    def follow
      CircleCi.request("#{base_path}/follow").post
    end

    ##
    # Get a checkout key for a project
    #
    # @param username     [String] - User or org name who owns project
    # @param project      [String] - Name of project
    # @param fingerprint  [String] - Fingerprint of a checkout key
    #
    # @return             [CircleCi::Response] - Response object
    def get_checkout_key(fingerprint)
      CircleCi.request("#{base_path}/checkout-key/#{fingerprint}").get
    end

    ##
    # Get a list of checkout keys for project
    #
    # @param username [String] - User or org name who owns project
    # @param project  [String] - Name of project
    #
    # @return         [CircleCi::Response] - Response object
    def list_checkout_keys
      CircleCi.request("#{base_path}/checkout-key").get
    end

    ##
    # Create a checkout key for a project
    #
    # @param type     [String] - The type of key to create. Can be 'deploy-key' or 'github-user-key'.
    # @return         [CircleCi::Response] - Response object

    def new_checkout_key(username, project, type)
      CircleCi.request("#{base_path}/checkout-key").post(type: type)
    end

    ##
    # Get all recent builds for a specific project
    #
    # @param params   [Hash] - Parameters for builds (limit, offset, filter)
    # @return         [CircleCi::Response] - Response object

    def recent_builds(params = {})
      CircleCi.request("#{base_path}", params).get
    end

    ##
    # Get all recent builds for a specific branch of a project
    #
    # @param branch   [String] - Name of branch
    #
    # @return         [CircleCi::Response] - Response object
    def recent_builds_branch(branch)
      CircleCi.request("#{base_path}/tree/#{branch}").get
    end

    ##
    # Get the project configuration
    #
    # @return         [CircleCi::Response] - Response object
    def settings
      CircleCi.request("#{base_path}/settings").get
    end

    ##
    # Add a ssh key to a project
    #
    # @param key      [String] - The ssh private key
    # @param hostname [String] - The hostname identified by the key
    # @return         [CircleCi::Response] - Response object
    def add_ssh_key(key, hostname)
      body = { hostname: hostname, private_key: key }
      CircleCi.request("#{base_path}/ssh-key").post(body)
    end

    ##
    # Unfollow the project
    #
    # @return         [CircleCi::Response] - Response object
    def unfollow
      CircleCi.request("#{base_path}/unfollow").post
    end

  private 
    def base_path
      "/project/#{vcs_type}/#{username}/#{name}"
    end
  end
end
