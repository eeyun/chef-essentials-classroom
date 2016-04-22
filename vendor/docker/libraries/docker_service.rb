module DockerCookbook
  require_relative 'docker_service_base'

  class DockerService < DockerServiceBase
    resource_name :docker_service

    # register with the resource resolution system
    provides :docker_service

    # installation type and service_manager
    property :install_method, %w(binary script package none auto), default: 'auto', desired_state: false
    property :service_manager, %w(execute sysvinit upstart systemd auto), default: 'auto', desired_state: false

    # docker_installation_script
    property :repo, desired_state: false
    property :script_url, String, desired_state: false

    # docker_installation_binary
    property :checksum, String, desired_state: false
    property :docker_bin, String, desired_state: false
    property :source, String, desired_state: false

    # docker_installation_package
    property :package_version, String, desired_state: false

    # binary and package
    property :version, String, desired_state: false
    property :package_options, [String, nil], desired_state: false

    ################
    # Helper Methods
    ################
    def validate_install_method
      if property_is_set?(:version) &&
         install_method != 'binary' &&
         install_method != 'package'
        raise Chef::Exceptions::ValidationFailed, 'Version property only supported for binary and package installation methods'
      end
    end

    def copy_properties_to(to, *properties)
      properties = self.class.properties.keys if properties.empty?
      properties.each do |p|
        # If the property is set on from, and exists on to, set the
        # property on to
        if to.class.properties.include?(p) && property_is_set?(p)
          to.send(p, send(p))
        end
      end
    end

    action_class.class_eval do
      def installation(&block)
        case install_method
        when 'auto'
          install = docker_installation(name, &block)
        when 'binary'
          install = docker_installation_binary(name, &block)
        when 'script'
          install = docker_installation_script(name, &block)
        when 'package'
          install = docker_installation_package(name, &block)
        when 'none'
          Chef::Log.info('Skipping Docker installation. Assuming it was handled previously.')
          return
        end
        copy_properties_to(install)
        install
      end

      def svc_manager(&block)
        case service_manager
        when 'auto'
          svc = docker_service_manager(name, &block)
        when 'execute'
          svc = docker_service_manager_execute(name, &block)
        when 'sysvinit'
          svc = docker_service_manager_sysvinit(name, &block)
        when 'upstart'
          svc = docker_service_manager_upstart(name, &block)
        when 'systemd'
          svc = docker_service_manager_systemd(name, &block)
        end
        copy_properties_to(svc)
        svc
      end
    end

    #########
    # Actions
    #########

    action :create do
      validate_install_method

      installation do
        action :create
        notifies :restart, new_resource
      end
    end

    action :delete do
      installation do
        action :delete
      end
    end

    action :start do
      svc_manager do
        action :start
      end
    end

    action :stop do
      svc_manager do
        action :stop
      end
    end

    action :restart do
      svc_manager do
        action :restart
      end
    end
  end
end
