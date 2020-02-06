# frozen_string_literal: true

require 'rake'

###############################################################################
#   ansible helper
###############################################################################
namespace :ansible do
  desc 'create new role'
  task :create_role do
    # check if we have a valid role name
    if ARGV.size == 1
      puts 'please set the role name as argument like `rake ansible:create_role foo`'
      exit(1)
    end

    # set some vars
    role = ARGV.last

    # check if the site already exists
    if Dir.exist?("roles/#{role}")
      puts 'This role already exists.'
      exit(1)
    end

    sh "ansible-galaxy init --init-path=roles/ #{role}"

    puts "#{role} is ready, happy hacking!"
    exit(0)
  end

  desc 'install requirements'
  task :install do
    sh 'ansible-galaxy install -r requirements.yml'
  end

  desc 'update requirements'
  task :update do
    sh 'ansible-galaxy install --force -r requirements.yml'
  end
end



###############################################################################
#   site handler
###############################################################################
namespace :site do
  # The site being created, is compatible with auto discovery @see below
  desc 'Create new ansible site (playbook, inventory, vault) and open the vault after it.'
  task :create do
    # check if we have a valid site name
    if ARGV.size == 1
      puts 'please set the site name as argument like `rake site:create foo`'
      exit(1)
    end

    # set some vars
    site = ARGV.last
    vault = "#{site}.vault.yml"
    vault_password_file = ".vault_#{site}_pass"
    playbook = "#{site}.playbook.yml"

    # check if the site already exists
    if File.exist?(playbook)
      puts 'This site already exists, please remove it manually if you want to replace it.'
      exit(1)
    end

    # create a random vault password
    File.open(vault_password_file, 'w') { |file| file.write(random_password) }

    # copy templates
    sh "cp .playbook.templ.yml #{playbook}"
    sh "cp .inventory.templ.yml #{site}.inventory.yml"

    # create vault
    sh "ansible-vault create #{vault} --vault-password-file=.vault_#{site}_pass"

    puts "#{site} is ready. Open #{playbook} in editor."
    exit(0)
  end
end

###############################################################################
# Autodiscovery for ansible sites
###############################################################################
FileList['./*.playbook.yml'].each do |task|
  name = task.gsub(/\.\/|\.yml\z|\.playbook/, '')

  namespace "#{name}" do
    inventory = "#{name}.inventory.yml"
    vault = "#{name}.vault.yml"
    vault_password_file = ".vault_#{name}_pass"

    desc "Deploy to #{name}"
    task "deploy" do
      sh "ansible-playbook #{task} -e @#{vault} --vault-password-file=#{vault_password_file} -i #{inventory}"
    end

    desc "Prepare hosts for ansible in #{inventory}"
    task "prepare" do
      sh "ansible-playbook _prep_host.yml --user root -i #{inventory}"
    end

    desc "Run ping against nodes of #{name} "
    task "ping" do
      sh "ansible all -m ping -i #{inventory}"
    end

    desc "Show node setup of #{name}"
    task "describe-setup" do
      sh "ansible all -m setup -i #{inventory}"
    end

    desc "Edit #{vault} for editing"
    task "vault" do
      sh "ansible-vault edit #{vault} --vault-password-file=#{vault_password_file}"
    end
  end
end

###############################################################################
#   some helper methods
###############################################################################

CHARS = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a
def random_password(length=23)
  CHARS.sort_by { rand }.join[0...length]
end