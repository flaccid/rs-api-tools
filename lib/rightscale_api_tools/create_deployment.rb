module RightScaleAPITools
  class CreateDeployment < Thor
    
    require 'yesno'
    require 'yaml'
    require 'rightscale_metadata'
      
    desc "", "Creates a RightScale deployment."
    long_desc <<-LONGDESC
`rs-create-deployment` creates a deployment by name or supplied metadata.\n

examples:\n
rs-create-deployment --name Gremlins\n
rs-create-deployment --metadata https://raw.github.com/rightscale-meta/deployments/master/base_servertemplate_for_linux_v13.5.yaml --edit"\n
rs-create-deployment --metadata rightscale.yaml"\n
    LONGDESC

    class_option :name,
      :default => false,
      :required => false,
      :banner => "<deployment_name>",
      :aliases => '-n',
      :desc => 'Name of the deployment.'
    class_option :description,
      :default => false,
      :required => false,
      :banner => "<deployment_desc>",
      :desc => 'Description of the deployment.'
    class_option :metadata,
      :default => false,
      :required => false,
      :banner => "<rightscale_metadata>",
      :aliases => '-m',
      :desc => 'A RightScale metadata file to use (merge) in creation of the resource.'
    class_option :edit,
      :type => :boolean,
      :default => false,
      :required => false,
      :desc => 'Edit the metadata before creation.'

    # include base class options
    eval(IO.read("#{File.dirname(File.expand_path(__FILE__))}/base_options.rb"), binding)

    def create()
      puts options.inspect if options[:debug]
      if !(options[:name] || options[:metadata]) 
        # need to invoke help here
        puts 'You must specify --name or --metadata. For more information run, rs-create-deployment help.'
        exit
      end

      deployment = Hash.new
      deployment['name'] = options[:name] if options[:name]
      deployment['description'] = options[:description] if options[:description]
      deployment['server_tag_scope'] = 'account'

      require 'right_api_client'
      require 'right_api_client_patch'
      rightscale = RightApi::Client.new(YAML.load_file(File.join(ENV['HOME'], '.rightscale', 'right_api_client.yml')))

      # creation via supply of metadata file
      if options[:metadata]
        metadata = RightScaleMetadata.new(options[:metadata]).metadata
        if options['edit']
          require 'securerandom'
          require 'editor_command'
          temp_path = "/tmp/rs-meta-#{Process.pid}-#{SecureRandom.hex}"
          puts "metadata tempfile: #{temp_path}" if options['debug'] if options['debug']
          IO.write(temp_path, YAML::dump(metadata))
          system("#{editor_command} #{temp_path}")
          metadata = RightScaleMetadata.new(temp_path).metadata
        end
        deployment.merge!(metadata['deployment'])
      end

      puts "Creating deployment, '#{deployment['name']}'."
      puts deployment if (options['verbose'] || options['debug'])

      if options['dry']
        puts 'Dry run, skipping creation of deployment.'
        exit
      else
        created_deployment = rightscale.deployments.create({ :deployment => deployment })
        puts "Deployment created, #{rightscale.api_url}/acct/#{rightscale.account_id}/deployments/#{created_deployment.href.split('/')[-1]} (#{created_deployment.href})."  
      end

      # create servers if metadata is supplied
      if options[:metadata]
        puts 'Creating servers...'
        puts deployment['servers'] if options['debug']
        deployment['servers'].each { |server|
          server['instance'] = Hash.new
          server['deployment_href'] = created_deployment.href
      
          if server['server_template'].kind_of?(String)
            server['server_template'] = RightScaleMetadata.new(server['server_template']).metadata['server_template']
          end
          if server['server_template'].key? 'id'
            server['instance']['server_template_href'] = server['server_template']['id']
          else
            # import first
            puts "Importing publication, #{server['server_template']['publication_id']}."
            publication = rightscale.publications(:id => "#{server['server_template']['publication_id']}")
            import = publication.import
            puts "Imported '#{import.show.name}' [rev #{import.show.revision}] (#{import.show.href})."
            server['instance']['server_template_href'] = import.show.href
          end
      
          server['instance']['cloud_href'] = "/api/clouds/#{server['cloud_id']}"
          
          puts 'Creating server.'
          puts "server: #{server}" if (options['debug'] || options['verbose'])
          created_server = rightscale.servers.create({:server => server})
          puts "Server created, #{rightscale.api_url}/acct/#{rightscale.account_id}/servers/#{created_server.href.split('/')[-1]} (#{created_server.href})."
        }
      end
    end

    default_task :create
  end
end